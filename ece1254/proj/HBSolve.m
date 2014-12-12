function h = HBSolve( N, fileName, p )
   % HB Solve - This function uses the Harmonic Balance Method to solve the
   % steady state condtion of the circuit described in fileName. Harmonic
   % Frequencies are limited to N.
   % It returns the vector containing the unknowns of the circuit, v, ordered as
   % described in HarmonicBalance.m and the cpu time required to solve the
   % circuit using Newton's Method

   % p is an optional struct() parameter
   defp = struct( 'eI', 1e-6, 'edV', 1e-3, 'JcondTol', 1e-23, 'iterations', 50, 'subiterations', 50 ) ;

   if ( nargin < 3 )
      p = defp ;
   end

   % tolerances
   if ( ~isfield( p, 'eI' ) )
      p.eI = defp.eI ;
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

   h = HarmonicBalance( r, N, omega ) ;
   Y = h.Y ;
   Is = h.I ;
   R = length( r.G ) ;

   % Fourier Transform Matrix
   F = FourierMatrix( N, R ) ;

   % Newton's Method Parameters
   V0 = zeros( R * ( 2 * N+1 ), 1 ) ;

   totalIterations = 0 ;

   % Source Stepping
   lambda = 0 ;
   plambda = 0 ;
   dlambda = 0.01 ;
   converged = 0 ;
   ecputime = cputime ;
   for i = 1:p.iterations
      V = V0 ;
      v = F * V ;

      % determine non linear currents
      inl = gnl( r.bdiode, v, N, R ) ;
      Inl = F\inl ;

      % Function to minimize I
      I = Y * V + Inl - lambda * Is ;

      % Construct Jacobian
      Gp = Gprime( r.bdiode, v, N, R ) ;
      J = Y + Gp ;

      disp( ['starting iteration ' num2str( i ) ' lambda is ' num2str( lambda ) ' norm of V0 = ' num2str( norm( V0 ) )] ) ;

      stepConverged = 0 ;

      for k = 1:p.subiterations

         % Newton Iteration Update
         dX = J\-I ;
         V = V + dX ;
         v = F * V ;

         % determine non linear currents
         inl = gnl( r.bdiode, v, N, R ) ;
         Inl = F\inl ;

         % Function to minimize I
         I = Y * V + Inl - lambda * Is ;

         % Construct Jacobian
         Gp = Gprime( r.bdiode, v, N, R ) ;
         J = Y + Gp ;

         if ( ( rcond( J ) < p.JcondTol ) || ( isnan( rcond( J ) ) ) )
            stepConverged = 0 ;
            break
         end

         if ( norm( I ) < p.eI ) || ( norm( dX ) < p.edV )
            stepConverged = 1 ;
            break ;
         end
      end

      if ( stepConverged ) % solution did not converge
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
      disp( ['solution converged after ' num2str( totalIterations ) ' p.iterations '] ) ;
   else
      disp( 'solution did not converge' ) ;
   end

   % return this function's data along with the return data from HarmonicBalance().
   h.v = v ;
   h.V = V ;
   h.ecputime = ecputime ;
   h.omega = omega ;
   h.R = R ;
end
