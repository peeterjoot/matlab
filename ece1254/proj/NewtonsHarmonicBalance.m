function r = NewtonsHarmonicBalance( N, filename, p )
   % NewtonsHarmonicBalance: Harmonic Balance equations of the form
   %
   %      f(V) = Y V - I - II(V),
   %
   % are constructed from the supplied .netlist specification.  
   % The zeros of this function are sought, determining the
   % the DFT Fourier coefficent vector V that solves the system in the frequency domain.
   %
   % PARAMETERS:
   %
   % - N [positive integer]:
   %
   %      The number of frequencies to include in Fourier series.
   %
   % - filename [string]:
   %
   %      The path for a .netlist file that specifies the circuit to solve.
   %
   % - p.tol [double]:
   % - p.tolF [double]:
   % - p.tolV [double]:
   % - p.tolRel [double]:
   %
   %      Iteration stops when all of:
   %         |f(x)| < p.tolF
   %         |\Delta x| < p.tolV
   %         |\Delta x|/|x| < p.tolRel
   %
   % If specified p.tol supplies defaults for all the other tol* threshold values.
   %
   % - p.maxIter [positive integer]:
   %
   %      Limit Newton's method search to this number of iterations (per stepping interval)
   %
   % - p.useStepping [boolean]:
   %
   %      Use source stepping, scaling sources by values 0:0.1:1
   %
   % - p is a struct parameter to override various optional parameters above.
   %
   % RETURNS:
   %
   % A struct() return that contains the results of NodalAnalysis()
   % and HarmonicBalance() plus the following fields:
   %
   % - r.V [vector]:
   %
   %     Solution in the frequency domain.
   %
   % - r.v [vector]:
   %
   %     Solution in the time domain.
   %
   % - r.f [vector]:
   %
   %     Value of f(V) at end of the iterations.
   %
   % - r.iter [integer]:
   %
   %      The last number of iterations for the final step interval.
   %
   % - r.normF [double]:
   %
   %      |f(V)| at the end of the last iteration.
   %
   % - r.normDeltaV [double]:
   %
   %      |\delta V| at the end of the last iteration.
   %
   % - r.totalIters [integer]:
   %
   %      Sum of last iter counts if useStepping is set (otherwise == iter).
   %

   defp = struct( 'tol', 1e-6, 'maxIter', 50, 'useStepping', 1, 'deltaLambda', 0.1, 'JcondTol', 1e-23 ) ;
   if ( nargin < 3 )
      p = defp ;
   end

   if ( ~isfield( p, 'tol' ) )
      p.tol = defp.tol ;
   end
   if ( ~isfield( p, 'tolF' ) )
      p.tolF = p.tol ;
   end
   if ( ~isfield( p, 'tolV' ) )
      p.tolV = p.tol ;
   end
   if ( ~isfield( p, 'tolRel' ) )
      p.tolRel = p.tol ;
   end
   if ( ~isfield( p, 'maxIter' ) )
      p.maxIter = defp.maxIter ;
   end
   if ( ~isfield( p, 'useStepping' ) )
      p.useStepping = defp.useStepping ;
   end
   if ( ~isfield( p, 'deltaLambda' ) )
      p.deltaLambda = defp.deltaLambda ;
   end
   % maximum allowed Jacobian Condition
   if ( ~isfield( p, 'JcondTol' ) )
      p.JcondTol = defp.JcondTol ;
   end

   haveFirstV = 0 ;
   totalIters = 0 ;

   %-------------------------------------------------------------------------------------------------
   %
   % Setup for first Newton's iteration
   %

   r = NodalAnalysis( filename ) ;

   %
   % Question: How to find the fundamental frequency?  
   % We have a set that we want to cast into the following form:
   %
   %  [omega1, omega2, omega3, ...] = \omega_0 [k, j, l, ...] (k, j, l, ...: integers)
   %
   % and then find the biggest \omega_0 for which this can be solved in integers (k,j, l, ...)
   %
   % Example:
   %
   %   [3.3 5.5 7.7] = 1.1 * [3 5 7]
   %
   % I'm not sure how to do such a non-integer factoring in general?
   %
   % This could be avoided if the .netlist file specifies the fundamental frequency explicitly, and this is
   % passed back from NodalAnalysis as metadata.
   %
   % For now, just assume that the smallest nonzero frequency source that came out of the netlist
   % is the fundamental frequency.  To force this, a very small magnitude source with the fundamental frequency
   % could be included in the .netlist file if it is not already there.
   %
   %omega = min( r.angularVelocities( find( r.angularVelocities > 0 ) ) ) ;
   omega = min( r.angularVelocities( r.angularVelocities > 0 ) ) ;

   traceit( sprintf( 'angularVelocities = %s, omega = %e', mat2str( r.angularVelocities ), omega ) ) ;
   %------------------------------------------------------------------------------------------

   r = HarmonicBalance( r, N, omega ) ;

   %-----------------

   R = size( r.xnames, 1 ) ;

   % for stepping use the last computed value of V
   V = rand( size( r.Y, 1 ), 1 ) ; %+ 1j * rand( size( r.Y, 1 ), 1 ) ;
   %V = zeros( size( r.Y, 1 ), 1 ) ;
   %V = ones( size( r.Y, 1 ), 1 ) ;

   lambda = p.deltaLambda/2 ;
   dLambda = p.deltaLambda ;
   dLambdas = [] ;

   while ( lambda <= 1 )
      stepConverged = 1 ;
      
%save( 'a.mat' ) ;
%break ;
      [II, JI] = DiodeCurrentAndJacobian( r, V ) ;

      J = r.Y - lambda * JI ;

      f = r.Y * V - lambda * II - r.I ;

      normF = norm( f ) ;
      %-------------------------------------------------------------------------------------------------

      iter = 0 ;
      while ( iter < p.maxIter )
         traceit( sprintf( 'lambda:%2.2e: %d iterations (%d total). |f| = %e', lambda, iter, totalIters, normF ) ) ;

         iter = iter + 1 ;
         totalIters = totalIters + 1 ;

         deltaV = -J\f ;
         V = V + deltaV ;

         %---------------------------------------------------------------
         % repeat all the non-linear calculations that are V dependent
         [II, JI] = DiodeCurrentAndJacobian( r, V ) ;

         J = r.Y - lambda * JI ;

         f = r.Y * V - lambda * II - r.I ;
         %---------------------------------------------------------------

         normF = norm( f ) ;
         normV = norm( V ) ;
         normDeltaV = norm( deltaV ) ;
         relDiffV = normDeltaV/normV ;

         nextStep = ((normF < p.tolF) && (normDeltaV < p.tolV)) ;

         rc = rcond( J ) ;

         if ( ( rc < p.JcondTol ) || isnan( rc ) )
            stepConverged = 0 ;
            break
         end

         % don't do relative checks for lambda == 0.  Have absolute convergence there, but also really small
         % normV.
         if ( lambda )
            nextStep == (nextStep && (relDiffV < p.tolRel)) ;
         end

         if ( nextStep )
            break ;
         end
      end

      if ( (iter >= p.maxIter) || ~stepConverged )
         disp( sprintf( 'lambda:%e: did not converge after %d iterations. |f| = %e, |V| = %e, rcond(J) = %e', lambda, iter, normF, normV, rc ) ) ;
      else
         disp( sprintf( 'lambda:%e: converged after %d iterations (%d total). |f| = %e, |V| = %e', lambda, iter, totalIters, normF, normV ) ) ;
      end

      if ( stepConverged )
         lambda = lambda + dLambda ;

         dLambdas(end+1) = dLambda ;
   
         movingAverageNumTerms = 2 ;
         if ( length(dLambdas) >= (movingAverageNumTerms) )
            dLambda = sum(dLambdas(end-movingAverageNumTerms+1:end))/movingAverageNumTerms ;
         end
      else
         dLambda = dLambda/2 ;
      end
   end

   % also return a time domain conversion right out of the box:
   v = zeros( size( V ) ) ;
   for i = 1:R
      v( i : R : end ) = r.F * V( i : R : end ) ;
   end

   % return any of the optional input parameters for reference so the caller
   % can see what defaults were applied (if any).
   r.maxIter      = p.maxIter ;
   r.tolF         = p.tolF ;
   r.tolRel       = p.tolRel ;
   r.tolV         = p.tolV ;
   r.useStepping  = p.useStepping ;

   % regular output parameters:
   r.v            = v ;
   r.V            = V ;
   r.R            = R ;
   r.II           = II ;
   r.f            = f ;
   r.iter         = iter ;
   r.normF        = normF ;
   r.normDeltaV   = normDeltaV ;
   r.totalIters   = totalIters ;
   r.omega        = omega ;
end
