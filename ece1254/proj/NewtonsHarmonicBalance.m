function [V, Vnames, F, Fbar, f, iter, normF, normDeltaV, totalIters] = NewtonsHarmonicBalance( filename, N, tolF, tolV, tolRel, maxIter, useStepping )
   % NewtonsHarmonicBalance: Harmonic Balance equations of the form
   %
   %      f(V) = Gd V - I -II(V),
   %
   %   are constructed from the supplied .netlist specification.  The zeros of this function are sought, determining the
   %   the DFT Fourier coefficent vector V that solves the system in the frequency domain.
   %
   %   PARAMETERS:
   %
   %      filename [string]:
   %
   %         The path for a .netlist file that specifies the circuit to solve.
   %
   %      N [positive integer]:
   %
   %         The number of frequencies to include in Fourier series.
   %
   %      tolF [double]:
   %      tolV [double]:
   %      tolRel [double]:
   %
   %         Iteration stops when all of:
   %            |f(x)| < tolF
   %            |\Delta x| < tolV
   %            |\Delta x|/|x| < tolRel
   %
   %      maxIter [positive integer]:
   %
   %         Limit Newton's method search to this number of iterations (per stepping interval)
   %
   %      useStepping [boolean]:
   %
   %         use source stepping, scaling sources by values 0:0.1:1
   %
   % Returns:
   %
   %  V [vector]:
   %
   %     Solution in frequency domain.
   %
   %  Vnames [vector]:
   %
   %     Descriptions of all the variables solved for.
   %
   %  f [vector]:
   %
   %     Value of f(V) at end of the iterations.
   %
   %   F,Fbar [matrix]:
   %
   %      To convert back to time domain
   %
   %   iter [integer]:
   %
   %      The last number of iterations for the final step interval.
   %
   %   normF [double]:
   %
   %      |f(V)| at the end of the last iteration.
   %
   %   normDeltaV [double]:
   %
   %      |\delta V| at the end of the last iteration.
   %
   %   totalIters [integer]:
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

      [G, C, B, angularVelocities, D, bdiode, xnames] = NodalAnalysis( filename, lambda ) ;

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
      omega = min( find( angularVelocities > 0 ) ) ;
      %------------------------------------------------------------------------------------------

      [Gd, Vnames, I, F, Fbar] = HarmonicBalance( G, C, B, angularVelocities, D, bdiode, xnames, N, omega ) ;

      R = size( xnames, 1 ) ;

      % for stepping use the last computed value of V
      if ( ~haveFirstV )
         V = rand( size( Gd, 1 ), 1 ) ;
         %V = zeros( size( Gd, 1 ), 1 ) ;
      end

      [II, JI] = DiodeCurrentAndJacobian( Gd, F, Fbar, D, bdiode, V ) ;

      J = Gd - JI ;

      f = Gd * V - I - II ;
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
         [II, JI] = DiodeCurrentAndJacobian( Gd, F, Fbar, D, bdiode, V ) ;

         J = Gd - JI ;

         f = Gd * V - I - II ;
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

%      disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x, f, normDeltaV, relDiffV ) ) ;
end
