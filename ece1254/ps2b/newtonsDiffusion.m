function [x, r] = newtonsDiffusion( N, V, tolF, tolX, tolRel, maxIter, numStepIntervals, noDamping )
% sample calls:
% 
% V=1;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1, 1 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y ) ; xlabel( 'x' ) ; ylabel( '\psi(x)' ) ;
% (4 iters)
%
% V=20;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1, 0 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
% (8 iters)
% V=20;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1, 1 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
% (16 iters)
%
% V=100;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1, 1 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
% (91 iters)
% V=100;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 1, 0 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
% (89 iters)
% V=100;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 5, 0 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
% (100 iters)
% V=100;ee=1e-6;[x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, 5, 1 ) ; y = [ -V;x;V ] ; plot( 0:r.deltaX:1, y )
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
% N [in]: number of sampling points (not including end points).  solution vector x has components: x_i = psi( u_i )
%
% +-V: values at x=1,0
%
% numStepIntervals [in]: 1 for no stepping.  Something higher to step the values of V from V/numStepIntervals to V.
%
% noDamping [in]: boolean: specify 1 to force alpha=1. 
%
% maxIter [in]: stop after this many iterations if not converged.
%
% iteration stops when all of:
%    ||F|| < tolF
%    ||\Delta x|| < tolX
%    ||\Delta x||/||x|| < tolRel
%
% returns:
%    x: solution vector.
%    r: A struct of various auxillary things to return of potential interest
%       r.F: value of (vector) function at end of the iteration.
%       r.totalIterations: total number of iterations
%       r.normF: ||F(x)|| at the end of the iteration.
%       r.normDx: ||x|| at the end of the iteration.
%       r.beta: damping factor
%       r.G: linear portion of the nodal matrix.

r = struct( 'allX', {} ) ;

nOnes = ones( N, 1 ) ;
G = sparse( diag(2 * nOnes, 0) - diag(nOnes(1:N-1), -1) - diag(nOnes(1:N-1), 1) ) ;
b = zeros( N, 1 ) ;
x = b ;
r(1).allX = x ;

b(1,1) = -V ;
b(N,1) = V ;

r.deltaX = 1/(N+1) ;
deltaXsq = r.deltaX * r.deltaX ;
hcoeff = 2 * deltaXsq ;
% H(x) = hcoeff * sinh( x(1:N) ) 
% F(x) = G * x - b + H(x)
%      = G * x - b + hcoeff * sinh( x(1:N) )

traceit( 'i & lambda & alpha & max |x_i| & |F| & |dx| & |dx|/|x|' ) ;

lambdas = 1/numStepIntervals:1/numStepIntervals:1 ;

r.beta = sqrt(norm( full(inv(G)), 2 )) ;
rho = hcoeff * V ;
maxForNewtons = 1/(r.beta * rho) ;

r.totalIterations = 0 ;
for lambda = lambdas
   F = G * x - lambda * b + hcoeff * sinh( x(1:N) ) ;
   r.normDx = 0 ;
   r.relDiffX = 0 ;
   r.normF = norm( F ) ;

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

      lastX = x ;

      if ( (r.normF <= maxForNewtons) || noDamping )
         alpha = 1 ;
      else
         alpha = maxForNewtons / r.normF ;
      end

      x = lastX + alpha * delta ;
      r.allX(:,end+1) = x ;
      H = hcoeff * sinh( x(1:N) ) ;
      F = G * x - lambda * b + H ;
      r.normF = norm( F ) ;

      if ( 0 == mod(iter, 10) || iter < 10 || iter > 80 )
         traceit( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), r.normF, r.normDx, r.relDiffX ) ) ;
      end

      iter = iter + 1 ;
      r.totalIterations = r.totalIterations + 1 ;

      dx = x - lastX ;
      r.normDx = norm( dx ) ;
      r.relDiffX = r.normDx/norm( lastX ) ;

      if ( (r.normF < tolF) && (r.normDx < tolX) && (r.relDiffX < tolRel) )
         break ;
      end
   end

   traceit( sprintf( '%d & %f & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, lambda, alpha, max(abs(x)), r.normF, r.normDx, r.relDiffX ) ) ;
end

r.F = F ;
r.G = G ;
