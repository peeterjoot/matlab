function [x, f, iter, absF, diffX] = newtonsDiode( lastX, tolF, tolX, tolRel, maxIter )

iter = 0 ;
diffX = 0 ;
relDiffX = 0 ;

x = lastX ;
f = diode( lastX ) ;

absF = abs( f ) ;
%stats = [] ;
%[ absF ; diffX ] ;

while ( iter < maxIter )
   fp = ddiode( lastX ) ;

   % the trailing bound of this instrumentation inserted after fact to see 
   % how the last iterations went.
   %
   if ( ( 0 == mod(iter, 50) ) || (iter < 10) || (iter > 380) )
      disp( sprintf( 'i: %d, x = %f, f = %2.1e, fp = %2.1e, |dx| = %2.1e, relDiff=%2.1e', iter, x, f, fp, diffX, relDiffX ) ) ;
   end

   x = lastX - f/ddiode( lastX ) ;
   f = diode( x ) ;
   absF = abs( f ) ;
   iter = iter + 1 ;

   diffX = abs( x - lastX ) ;
   relDiffX = diffX/lastX ;
   lastX = x ;

   if ( (absF < tolF) && (diffX < tolX) && (relDiffX < tolRel) )
      break ;
   end
   %stats(end+1) = absF ;
   %stats(end+1) = diffX ;
end

disp( sprintf( 'i: %d, x = %f, f = %2.1e, fp = %2.1e, |dx| = %2.1e, relDiff=%2.1e', iter, x, f, fp, diffX, relDiffX ) ) ;
