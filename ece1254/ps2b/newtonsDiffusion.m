function [x, F, normF, normDx, totalIters, deltaX] = newtonsDiffusion( N, V, tolF, tolX, tolRel, maxIter, numStepIntervals )
% sample calls:
% 
% V=1;ee=1e-6;[x, F, nF, dx, i, d] = newtonsDiffusion( 100, V, ee, ee, ee, 50, 1 ) ; y = [ -V;x;V ] ; plot( 0:d:1, y )
% (4 iters)
%
% V=20;ee=1e-6;[x, F, nF, dx, i, d] = newtonsDiffusion( 100, V, ee, ee, ee, 50, 1 ) ; y = [ -V;x;V ] ; plot( 0:d:1, y )
% (16 iters, 28 iters with 5 steps)
%
% V=100;ee=1e-6;[x, F, nF, dx, i, d] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1 ) ; y = [ -V;x;V ] ; plot( 0:d:1, y )
% (91 iters)
% V=100;ee=1e-6;[x, F, nF, dx, i, d] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 5 ) ; y = [ -V;x;V ] ; plot( 0:d:1, y )
% (37 iters)
%
% solve: F(x) = G * x - b + 2 [sinh(x_i)]_i
%        b(1) = -V, b(N) = V, b({else}) = 0.
%        G = 2 I - P - P^T, where P is ones on the superdiagonal, and zeros elsewhere.
% 
% This are the nodal equations for the finite approximation of the nonlinear Poisson equation:
%
%    d^2 psi/du^2 = 2 sinh( psi(u) ), psi(0) = -V, psi(1) = V, u in [0,1]
%
% N: number of sampling points (not including end points).  solution vector x has components: x_i = psi( u_i )
%
% +-V: values at x=1,0
%
% numStepIntervals: 1 for no stepping.  Something higher to step the values of V from V/numStepIntervals to V.
%
% maxIter: stop after this many iterations if not converged.
%
% iteration stops when all of:
%    ||F|| < tolF
%    ||\Delta x|| < tolX
%    ||\Delta x||/||x|| < tolRel
%
% returns:
%    x: solution vector.
%    F: value of (vector) function at end of the iteration.
%    iter: last number of iterations
%    normF: ||F(x)|| at the end of the iteration.
%    normDx: ||x|| at the end of the iteration.

nOnes = ones( N, 1 ) ;
G = sparse( diag(2 * nOnes, 0) - diag(nOnes(1:N-1), -1) - diag(nOnes(1:N-1), 1) ) ;
b = zeros( N, 1 ) ;
x = b ;

b(1,1) = -V ;
b(N,1) = V ;

deltaX = 1/(N+1) ;
deltaXsq = deltaX * deltaX ;
hcoeff = 2 * deltaXsq ;
% H(x) = hcoeff * sinh( x(1:N) ) 
% F(x) = G * x - b + H(x)
%      = G * x - b + hcoeff * sinh( x(1:N) )

%disp( 'i & lambda & alpha & max |x_i| & Newton |F| & Damped |F| & |dx| & |dx|/|x|' ) ;
disp( 'i & lambda & alpha & max |x_i| & Newton |F| & |dx| & |dx|/|x|' ) ;

lambdas = 1/numStepIntervals:1/numStepIntervals:1 ;

totalIters = 0 ;
for lambda = lambdas
   F = G * x - lambda * b + hcoeff * sinh( x(1:N) ) ;
   normDx = 0 ;
   relDiffX = 0 ;
   normF = norm( F ) ;

   iter = 0 ;
   while ( iter < maxIter )
      JF = zeros( N ) ;
      % FIXME: how can this be vectorized?
      for i = 1:N
         JF(i,i) = hcoeff * cosh( x(i) ) ;
      end
      J = G + JF ;

      % adjustment for standard Newton's:
      delta = (-J)\F ;

      % damping adjustment if desirable:
      %alpha = -normF^2/(F.' * delta) ;

      lastX = x ;

      %dampedX = lastX + alpha * delta ;
      %dampedH = hcoeff * sinh( dampedX(1:N) ) ;
      %dampedF = G * dampedX - lambda * b + dampedH ;
      %normDampedF = norm( dampedF ) ;

      newtonsX = lastX + delta ;
      newtonsH = hcoeff * sinh( newtonsX(1:N) ) ;
      newtonsF = G * newtonsX - lambda * b + newtonsH ;
      normNewtonsF = norm( newtonsF ) ;

      %if ( normNewtonsF < normDampedF )
         x = newtonsX ;
         F = newtonsF ;
         normF = normNewtonsF ;
         alpha = 1 ;
      %else
      %   x = dampedX ;
      %   F = dampedF ;
      %   normF = normDampedF ;
      %end

      %disp( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), normNewtonsF, normDampedF, normDx, relDiffX ) ) ;
      disp( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), normNewtonsF, normDx, relDiffX ) ) ;

      iter = iter + 1 ;
      totalIters = totalIters + 1 ;

      dx = x - lastX ;
      normDx = norm( dx ) ;
      relDiffX = normDx/norm( lastX ) ;

      if ( (normF < tolF) && (normDx < tolX) && (relDiffX < tolRel) )
         break ;
      end
   end

   %disp( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), normNewtonsF, normDampedF, normDx, relDiffX ) ) ;
   disp( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), normNewtonsF, normDx, relDiffX ) ) ;
end
