function [x, f, iter, absF, diffX, totalIters] = newtonsDiode( lastX, tolF, tolX, tolRel, maxIter, useStepping )

if ( useStepping )
   lambdas = 0:0.1:1 ;
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

   while ( iter < maxIter )
      totalIters = totalIters + 1 ;

      fp = ddiode( lastX ) ;

      % the trailing bound of this instrumentation inserted after fact to see 
      % how the last iterations went.
      %
      if ( ( 0 == mod(iter, 50) ) || (iter < 10) || (iter > 380) )
%         disp( sprintf( 'lambda=%1.1f, i: %d, x = %f, f = %2.1e, fp = %2.1e, |dx| = %2.1e, relDiff=%2.1e', lambda, iter, x, f, fp, diffX, relDiffX ) ) ;
         disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x, f, diffX, relDiffX ) ) ;
      end

      x = lastX - f/ddiode( lastX ) ;
      f = diode( x, lambda ) ;
      absF = abs( f ) ;
      iter = iter + 1 ;

      diffX = abs( x - lastX ) ;
      relDiffX = diffX/lastX ;
      lastX = x ;

      if ( (absF < tolF) && (diffX < tolX) && (relDiffX < tolRel) )
         break ;
      end
   end

   %disp( sprintf( 'lambda=%f, i: %d, x = %f, f = %2.1e, fp = %2.1e, |dx| = %2.1e, relDiff=%2.1e', lambda, iter, x, f, fp, diffX, relDiffX ) ) ;
   disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x, f, diffX, relDiffX ) ) ;
end
