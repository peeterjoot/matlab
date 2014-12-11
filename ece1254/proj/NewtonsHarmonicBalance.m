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

   defp = struct( 'tol', 1e-6, 'maxIter', 50, 'useStepping', 0, 'deltaLambda', 0.1 ) ;
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

   if ( p.useStepping )
      lambdas = 0:p.deltaLambda:1 ;
   else
      lambdas = [ 1 ] ;
   end

   haveFirstV = 0 ;

   for lambda = lambdas
      %-------------------------------------------------------------------------------------------------
      %
      % Setup for first Newton's iteration
      %

      r = NodalAnalysis( filename, lambda ) ;

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
      omega = min( r.angularVelocities( find( r.angularVelocities > 0 ) ) ) ;

      traceit( sprintf( 'angularVelocities = %s, omega = %e', mat2str( r.angularVelocities ), omega ) ) ;
      %------------------------------------------------------------------------------------------

      r = HarmonicBalance( r, N, omega ) ;

      %-----------------
      % precalculate the Fourier transform matrix pairs and cache them:
      F = FourierMatrixComplex( N ) ;

      Finv = conj( F )/( 2 * N + 1 ) ;

      r.F = F ;
      r.Finv = Finv ;
      %-----------------

      R = size( r.xnames, 1 ) ;

      % for stepping use the last computed value of V
      if ( ~haveFirstV )
         V = rand( size( r.Y, 1 ), 1 ) + 1j * rand( size( r.Y, 1 ), 1 ) ;
         %V = zeros( size( r.Y, 1 ), 1 ) ;
         %V = ones( size( r.Y, 1 ), 1 ) ;
      end

      [II, JI] = DiodeCurrentAndJacobian( r, V ) ;

      J = r.Y - JI ;

      f = r.Y * V - r.I - II ;
      %-------------------------------------------------------------------------------------------------

      iter = 0 ;
      totalIters = 0 ;
      while ( iter < p.maxIter )
         totalIters = totalIters + 1 ;

         lastV = V ;
         lastF = f ;

         deltaV = -J\f ;
         V = V + deltaV ;

         %---------------------------------------------------------------
         % repeat all the non-linear calculations that are V dependent
         [II, JI] = DiodeCurrentAndJacobian( r, V ) ;

         J = r.Y - JI ;

         f = r.Y * V - r.I - II ;
         %---------------------------------------------------------------

         normF = norm( f ) ;
         normV = norm( V ) ;
         normDeltaV = norm( deltaV ) ;
         relDiffV = normDeltaV/normV ;

         if ( (normF < p.tolF) && (normDeltaV < p.tolV) && (relDiffV < p.tolRel) )
            break ;
         end

         iter = iter + 1 ;
      end

      if ( iter >= p.maxIter )
         disp( 'did not converge after %d iterations', iter ) ;
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
