function [x, f, iter, absF, diffX] = newtonsSquareroot( a, x, tolF, tolX, tolRel, maxIter )
% 
% solve: f(x) = x^2 - a = 0
% 
% examples:
%   [x, f, iter, absF, diffX] = newtonsSquareroot( 2, 0, 1e-6, 1e-6, 1e-6, 50 ) ;
%   [x, f, iter, absF, diffX] = newtonsSquareroot( 2, 0.1, 1e-6, 1e-6, 1e-6, 10 ) ;
%   [x, f, iter, absF, diffX] = newtonsSquareroot( 2, 100000000000, 1e-6, 1e-6, 1e-6, 100 ) ;
%
% Despite notes about non-convergence for too-far away initial guesses in Najm's book (4.41), this seems to converge for all initial values != 0
%
% x: [in] initial guess.
% x: [out] final iterative value.
%
% maxIter: stop after this many iterations if not converged.
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


disp( 'i & x, f, \\( \\Abs{\\Delta x} \\) & \\( \\Abs{\\Delta x}/\\Abs{x} \\) \\\\ \\hline' ) ;
iter = 0 ;
f = x^2 - a ;
diffX = 0 ;
relDiffX = 0 ;
absF = abs( f ) ;
fp = 2 * x ;

while ( iter < maxIter )
   disp( sprintf( '%d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, x, f, diffX, relDiffX ) ) ;

   lastX = x ;
   x = x - f/fp ;
   f = x^2 - a ;
   fp = 2 * x ;

   absF = abs( f ) ;
   diffX = abs( x - lastX ) ;
   relDiffX = diffX/lastX ;

   if ( (absF < tolF) && (diffX < tolX) && (relDiffX < tolRel) )
      break ;
   end

   iter = iter + 1 ;
end

disp( sprintf( '%d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, x, f, diffX, relDiffX ) ) ;
