function [x, F, iter, normSqF, dxSquared] = newtonsDiffusion( N, V, tolF, tolX, tolRel, maxIter )
% sample call:
% 
% n=100;d=1/101;V=20;ee=1e-12;[x, F, iter, normSqF, dxSquared] = newtonsDiffusion( n, V, ee, ee, ee, 1000 ) ; y = [ -V;x;V ] ; plot( 0:d:1, y )
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
% maxIter: stop after this many iterations if not converged.
%
% iteration stops when all of:
%    ||F||^2 < tolF
%    ||\Delta x||^2 < tolX
%    ||\Delta x||^2/||x||^2 < tolRel
%
% returns:
%    x: solution vector.
%    F: value of (vector) function at end of the iteration.
%    iter: last number of iterations
%    normSqF: ||F(x)||^2 at the end of the iteration.
%    dxSquared: ||x||^2 at the end of the iteration.

nOnes = ones( N, 1 ) ;
G = sparse( diag(2 * nOnes, 0) - diag(nOnes(1:N-1), -1) - diag(nOnes(1:N-1), 1) ) ;
b = zeros( N, 1 ) ;
x = b ;

b(1,1) = -V ;
b(N,1) = V ;

deltaXsq = 1/(N+1)^2 ;
% H(x) = 2 * deltaXsq * sinh( x(1:N) ) 
% F(x) = G * x - b + H(x)
%      = G * x - b + 2 * deltaXsq * sinh( x(1:N) )

fp = 2 * deltaXsq ;

disp( 'i & alpha & max |x_i| & |F| & |dx| & |dx|/|x|' ) ;
iter = 0 ;
F = G * x - b + fp * sinh( x(1:N) ) ;
dxSquared = 0 ;
relDiffSqX = 0 ;
normSqF = F.' * F ;

while ( iter < maxIter )
   JF = zeros( N ) ;
   for i = 1:N
      JF(i,i) = fp * cosh( x(i) ) ;
   end
   J = G + JF ;

   delta = (-J)\F ;
   
%   Gdelta = G * delta ;
%   Hprime = zeros(N, 1) ;
%
%   % can this statement be vectorized like sinh( x(1:N) ) ?
%   for i = 1:N
%      Hprime(i) = fp * x(i) * cosh( x(i) ) ;
%   end
%
%   Fprime = Gdelta + Hprime ;
%
%   alpha = -(F.' * Fprime) / ( Gdelta.' * Fprime) ;
alpha=1;

%   if ( ( 0 == mod(iter, 50) ) || (iter < 10) )
      disp( sprintf( '%d & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, alpha, max(abs(x)), norm(F), sqrt(dxSquared), sqrt(relDiffSqX) ) ) ;
%   end

   lastX = x ;
   x = lastX + alpha * delta ;

% If x(i) gets large (~800), this will trigger: isinf( sinh(800) ) = 1.
   H = fp * sinh( x(1:N) ) ;

   F = G * x - b + H ;
   normSqF = F.' * F ;
   iter = iter + 1 ;

   dx = x - lastX ;
   dxSquared = dx.' * dx ;
   relDiffSqX = dxSquared/(lastX.' * lastX) ;
   lastX = x ;

   if ( (normSqF < tolF) && (dxSquared < tolX) && (relDiffSqX < tolRel) )
      break ;
   end
end

disp( sprintf( '%d & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, alpha, max(abs(x)), norm(F), sqrt(dxSquared), sqrt(relDiffSqX) ) ) ;
