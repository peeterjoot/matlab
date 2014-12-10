function [x, f, iter, absF, diffX, totalIters] = newtonsDiode( lastX, tolF, tolX, tolRel, maxIter, useStepping, useDerivative )
% solve: f(x, lambda) = x - lambda * 5 + 10^{-6} * e^{80 x}
%
% lastX: initial guess.
%
% maxIter: stop after this many iterations if not converged.
%
% useStepping: boolean: vary lambda \in [0,1], and proceed with previous estimate (otherwise lambda=1)
%
% iteration stops when all of:
%    |f(x)| < tolF
%    |\Delta x| < tolX
%    |\Delta x|/|x| < tolRel
%
% returns:
%    x: solution.
%    f: value of function at end of the iteration.
%    iter: last number of iterations
%    absF: |f(x)| at the end of the iteration.
%    diffX: |x| at the end of the iteration.
%    totalIters: sum of last iter counts if useStepping is set (otherwise == iter).


if ( useStepping )
   deltaLambda = 0.1 ;
   lambdas = 0:deltaLambda:1 ;
else
   lambdas = [ 1 ] ;
end

totalIters = 0 ;
disp( '\\( \\lambda \\) & i & x, f, \\( \\Abs{\\Delta x} \\) & \\( \\Abs{\\Delta x}/\\Abs{x} \\) \\\\ \\hline' ) ;
for lambda = lambdas
   iter = 0 ;
   x = lastX ;
   f = diode( lastX, lambda ) ;
   diffX = 0 ;
   relDiffX = 0 ;
   absF = abs( f ) ;
   fp = ddiode( lastX ) ;

   while ( iter < maxIter )
      totalIters = totalIters + 1 ;

      % the trailing bound of this instrumentation inserted after fact to see
      % how the last iterations went.
      %
      if ( ( 0 == mod(iter, 50) ) || (iter < 10) || (iter > 380) )
         disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x, f, diffX, relDiffX ) ) ;
      end

      x = lastX - f/fp ;
      f = diode( x, lambda ) ;
      absF = abs( f ) ;
      iter = iter + 1 ;

      diffX = abs( x - lastX ) ;
      relDiffX = diffX/lastX ;
      lastX = x ;

      fp = ddiode( lastX ) ;

      if ( (absF < tolF) && (diffX < tolX) && (relDiffX < tolRel) )
         break ;
      end
   end

   disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x, f, diffX, relDiffX ) ) ;

   if ( useDerivative )
      if ( lambda ~= lambdas(end) )
         lastX = lastX + deltaLambda * 5/fp ;
      end
   end
end
