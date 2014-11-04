function [x, f, iter, normSqF, dxSquared, totalIters] = newtonsDiffusion( N, V, tolF, tolX, tolRel, maxIter, useStepping )
% solve: F(x, lambda) = G * x - lambda * b + 2 [sinh(x_i)]_i
%        b(1) = -lambda * V, b(N) = lambda * V, b({else}) = 0.
%        G = 2 I - P - P^T, where P is ones on the superdiagonal, and zeros elsewhere.
% 
% This are the nodal equations for the finite approximation of the nonlinear Poisson equation:
%
%    d^2 psi/du^2 = 2 sinh( psi(u) ), psi(0) = -V, psi(1) = V.
%
% N: number of sampling points (not including end points).  solution vector x has components: x_i = psi( u_i )
%
% +-V: values at x=1,0
%
% maxIter: stop after this many iterations if not converged.
%
% useStepping: vary V \in [0,1] V, and proceed with previous estimate (otherwise use V).
%    The values lambda are taken from the interval [0,1].
%
% iteration stops when all of:
%    ||F||^2 < tolF
%    ||\Delta x||^2 < tolX
%    ||\Delta x||^2/||x||^2 < tolRel
%
% returns:
%    x: solution vector.
%    f: value of (vector) function at end of the iteration.
%    iter: last number of iterations
%    normSqF: ||F(x)||^2 at the end of the iteration.
%    dxSquared: ||x||^2 at the end of the iteration.
%    totalIters: sum of last iter counts if useStepping is set (otherwise == iter).

if ( useStepping )
   deltaLambda = 0.1 ;
   lambdas = 0:deltaLambda:1 ;
else
   lambdas = [ 1 ] ;
end

nOnes = ones( N, 1 ) ;
G = sparse( diag(2 * nOnes, 0) - diag(nOnes(1:n-1), -1) - diag(nOnes(1:n-1), 1) ) ;
b = zeros( N, 1 ) ;
lastX = b ;
b(1,1) = -V ;
b(N,1) = V ;
deltaXsq = 1/(N+1)^2 ;
% H(x) = 2 * deltaXsq * sinh( x(1:N) ) 
% F(x) = G * x - b + H(x)
%      = G * x - b + 2 * deltaXsq * sinh( x(1:N) )

totalIters = 0 ;
disp( '\\( \\lambda \\) & i & \\( \\Norm{ \\Bx }^2 \\) & \\( \\Norm{ F(\\Bx)}^2 \\) & \\( \\Norm{\\Delta x}^2 \\) & \\( \\Norm{\\Delta x}^2/\\Norm{x}^2 \\) \\\\ \\hline' ) ;
for lambda = lambdas
   iter = 0 ;
   x = lastX ;
   f = G * x - lambda * b + 2 * deltaXsq * sinh( x(1:N) ) ;
   dxSquared = 0 ;
   relDiffSqX = 0 ;
   normSqF = f.' * f ;
   fp = 2 * deltaXsq ;

   while ( iter < maxIter )
      totalIters = totalIters + 1 ;

      if ( ( 0 == mod(iter, 50) ) || (iter < 10) )
         disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x.' * x, f.' * f, dxSquared, relDiffSqX ) ) ;
      end

      x = lastX - f/fp ;
      f = G * x - lambda * b + 2 * deltaXsq * sinh( x(1:N) ) ;
      normSqF = f.' * f ;
      iter = iter + 1 ;

      dx = x - lastX ;
      dxSquared = dx.' * dx ;
      relDiffSqX = dxSquared/(lastX.' * lastX) ;
      lastX = x ;

      if ( (normSqF < tolF) && (dxSquared < tolX) && (relDiffSqX < tolRel) )
         break ;
      end
   end

   disp( sprintf( '%1.1f & %d & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', lambda, iter, x.' * x, f.' * f, dxSquared, relDiffSqX ) ) ;
end
