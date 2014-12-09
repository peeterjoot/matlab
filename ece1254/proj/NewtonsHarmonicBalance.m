function [r, xnames, Vnames] = NewtonsHarmonicBalance( filename, N, tolF, tolV, tolRel, maxIter, useStepping )
   % NewtonsHarmonicBalance: Harmonic Balance equations of the form
   %
   %      f(V) = Y V - I -II(V),
   %
   %   are constructed from the supplied .netlist specification.  The zeros of this function are sought, determining the
   %   the DFT Fourier coefficent vector V that solves the system in the frequency domain.
   %
   % PARAMETERS:
   %
   % - filename [string]:
   %
   %      The path for a .netlist file that specifies the circuit to solve.
   %
   % - N [positive integer]:
   %
   %      The number of frequencies to include in Fourier series.
   %
   % - tolF [double]:
   % - tolV [double]:
   % - tolRel [double]:
   %
   %      Iteration stops when all of:
   %         |f(x)| < tolF
   %         |\Delta x| < tolV
   %         |\Delta x|/|x| < tolRel
   %
   % - maxIter [positive integer]:
   %
   %      Limit Newton's method search to this number of iterations (per stepping interval)
   %
   % - useStepping [boolean]:
   %
   %      Use source stepping, scaling sources by values 0:0.1:1
   %
   % RETURNS:
   %
   % A struct() return that contains the results of NodalAnalysis() and HarmonicBalance() plus the following fields:
   %
   % - r.V [vector]:
   %
   %     Solution in frequency domain.
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

   if ( useStepping )
      deltaLambda = 0.1 ;
      lambdas = 0:deltaLambda:1 ;
   else
      lambdas = [ 1 ] ;
   end

   haveFirstV = 0 ;

   for lambda = lambdas
      %-------------------------------------------------------------------------------------------------
      %
      % Setup for first Newton's iteration
      %

      [r, xnames, bdiode] = NodalAnalysis( filename, lambda ) ;

      %
      % Question: How to find the fundamental frequency?  We have a set that we want to cast into the following form:
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

      [r, Vnames] = HarmonicBalance( r, xnames, N, omega ) ;

      R = size( xnames, 1 ) ;

      % for stepping use the last computed value of V
      if ( ~haveFirstV )
         V = rand( size( r.Y, 1 ), 1 ) + 1j * rand( size( r.Y, 1 ), 1 ) ;
         %V = zeros( size( r.Y, 1 ), 1 ) ;
         %V = ones( size( r.Y, 1 ), 1 ) ;
      end

      [II, JI] = DiodeCurrentAndJacobian( r, bdiode, V ) ;

      J = r.Y - JI ;

      f = r.Y * V - r.I - II ;
      %-------------------------------------------------------------------------------------------------

      iter = 0 ;
      totalIters = 0 ;
      while ( iter < maxIter )
         totalIters = totalIters + 1 ;

         lastV = V ;
         lastF = f ;

         deltaV = -J\f ;
         V = V + deltaV ;

         %---------------------------------------------------------------
         % repeat all the non-linear calculations that are V dependent
         [II, JI] = DiodeCurrentAndJacobian( r, bdiode, V ) ;

         J = r.Y - JI ;

         f = r.Y * V - r.I - II ;
         %---------------------------------------------------------------

         normF = norm( f ) ;
         normV = norm( V ) ;
         normDeltaV = norm( deltaV ) ;
         relDiffV = normDeltaV/normV ;

         if ( (normF < tolF) && (normDeltaV < tolV) && (relDiffV < tolRel) )
            break ;
         end

         iter = iter + 1 ;
      end
   end

   r.V          = V ;
   r.II         = II ;
   r.f          = f ;
   r.iter       = iter ;
   r.normF      = normF ;
   r.normDeltaV = normDeltaV ;
   r.totalIters = totalIters ;
   r.omega      = omega ;
end
