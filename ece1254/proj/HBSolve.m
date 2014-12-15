function h = HBSolve( N, fileName, p )
   % HB Solve - This function uses the Harmonic Balance Method to solve the
   % steady state condtion of the circuit described in fileName. Harmonic
   % Frequencies are limited to N.
   % It returns the vector containing the unknowns of the circuit, v, ordered as
   % described in HarmonicBalance.m and the cpu time required to solve the
   % circuit using Newton's Method

   % p is an optional struct() parameter
   defp = struct( 'tolF', 1e-6, 'edV', 1e-3, 'JcondTol', 1e-23, 'iterations', 50, 'subiterations', 50 ) ;

   if ( nargin < 3 )
      p = defp ;
   end

   % tolerances
   if ( ~isfield( p, 'tolF' ) )
      p.tolF = defp.tolF ;
   end
   if ( ~isfield( p, 'edV' ) )
      p.edV = defp.edV ;
   end

   % maximum allowed Jacobian Condition
   if ( ~isfield( p, 'JcondTol' ) )
      p.JcondTol = defp.JcondTol ;
   end

   % iteration limits
   if ( ~isfield( p, 'iterations' ) )
      p.iterations = defp.iterations ;
   end
   if ( ~isfield( p, 'subiterations' ) )
      p.subiterations = defp.subiterations ;
   end

   r = NodalAnalysis( fileName ) ;

   % Harmonic Balance Parameters
   % Only intend on using one frequency for all AC sources
   %omega = min( r.angularVelocities( find ( r.angularVelocities > 0 ) ) ) ;
   omega = min( r.angularVelocities( r.angularVelocities > 0 ) ) ;

   r = HarmonicBalance( r, N, omega ) ;
   R = length( r.G ) ;

   bigF = 1 ;

   if ( bigF )
      % Fourier Transform Matrix
      F = FourierMatrix( N, R ) ;
   end

   % Newton's Method Parameters
   V0 = zeros( R * ( 2 * N + 1 ), 1 ) ;

   totalIterations = 0 ;

   % Source Stepping
   lambda = 0 ;
   plambda = 0 ;
   dlambda = 0.01 ;
   converged = 0 ;
   ecputime = cputime ;
   for i = 1:p.iterations
      V = V0 ;

      if ( bigF )
         v = F * V ;

         % determine non linear currents
         inl = gnl( r.bdiode, v, N, R ) ;
         Inl = - F\inl ;

         % Construct Jacobian
         JI = - Gprime( r.bdiode, v, N, R ) ;
      else
         [Inl, JI] = DiodeCurrentAndJacobian( r, V ) ;
      end

      % Function to minimize:
      f = r.Y * V - Inl - lambda * r.I ;

      J = r.Y - JI ;

      disp( ['starting iteration ' num2str( i ) ' lambda is ' num2str( lambda ) ' norm of V0 = ' num2str( norm( V0 ) )] ) ;

      stepConverged = 0 ;

      for k = 1:p.subiterations

         % Newton Iteration Update
         dV = J\-f ;
         V = V + dV ;

         if ( bigF )
            v = F * V ;

            % determine non linear currents
            inl = gnl( r.bdiode, v, N, R ) ;
            Inl = - F\inl ;
            JI = - Gprime( r.bdiode, v, N, R ) ;
         else
            [Inl, JI] = DiodeCurrentAndJacobian( r, V ) ;
         end

         % Function to minimize:
         f = r.Y * V - Inl - lambda * r.I ;

         % Construct Jacobian
         J = r.Y - JI ;

         if ( ( rcond( J ) < p.JcondTol ) || ( isnan( rcond( J ) ) ) )
            stepConverged = 0 ;
            break
         end

         if ( norm( f ) < p.tolF ) || ( norm( dV ) < p.edV )
            stepConverged = 1 ;
            break ;
         end
      end

      if ( stepConverged )
         % disp( 'solution converged' )
         V0 = V ;
         dlambda = 2 * dlambda ;
         plambda = lambda ;
         lambda = lambda + dlambda ;
      else
         % disp( 'solution did not converge' )
         dlambda = dlambda/2 ;
         lambda = plambda + dlambda ;
      end

      totalIterations = totalIterations + k ;

      if ( plambda == 1 && stepConverged == 1 )
         converged = 1 ;
         break ;
      end

      if ( lambda >= 1 )
         lambda = 1 ;
      end

      if ( dlambda <= 0.0001 )
         error( 'source load step too small, function not converging' ) ;
      end
   end

   ecputime = cputime - ecputime ;

   if ( converged )
      disp( ['solution converged after ' num2str( totalIterations ) ' iterations '] ) ;
   else
      disp( 'solution did not converge' ) ;
   end

   % return this function's data along with the return data from HarmonicBalance().
   h = r ;
   if ( ~bigF )
      % also return a time domain conversion right out of the box:
      v = zeros( size( V ) ) ;
      for i = 1:R
         v( i : R : end ) = r.F * V( i : R : end ) ;
      end
   end
   h.v = v ;
   h.V = V ;
   h.ecputime = ecputime ;
   h.omega = omega ;
   h.R = R ;
end
