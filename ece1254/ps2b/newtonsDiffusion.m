function [x, F, iter, normSqF, dxSquared] = newtonsDiffusion( N, V, tolF, tolX, tolRel, maxIter )
% sample call:
% 
%     n = 5 ; d=1/6 ; [x, F, iter, normSqF, dxSquared] = newtonsDiffusion( n, 1, 1e-12, 1e-12, 1e-12, 1000 ) ; plot( d:d:n * d, x )
%     n=100 ; d=1/101 ; [x, F, iter, normSqF, dxSquared] = newtonsDiffusion( n, 8, 1e-12, 1e-12, 1e-12, 2000 ) ; plot( d:d:n * d, x )
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
lastX = b ;

% FIXME: See what may be ping-ponging at N=100,V=8,maxIter=2000
b(1,1) = -V ;
b(N,1) = V ;

deltaXsq = 1/(N+1)^2 ;
% H(x) = 2 * deltaXsq * sinh( x(1:N) ) 
% F(x) = G * x - b + H(x)
%      = G * x - b + 2 * deltaXsq * sinh( x(1:N) )

fp = 2 * deltaXsq ;
J = G + sparse( diag(fp * nOnes, 0) ) ;

% FIXME: use LU, but wait until I get base algorithm right.  
fpinv = inv( J ) ;

%disp( 'i & \\( \\alpha \\) & \\( \\Norm{ \\Bx } \\) & \\( \\Norm{ F(\\Bx)} \\) & \\( \\Norm{\\Delta x} \\) & \\( \\Norm{\\Delta x}/\\Norm{x} \\) \\\\ \\hline' ) ;
disp( 'i & alpha & max |x_i| & |F| & |dx| & |dx|/|x|' ) ;
iter = 0 ;
x = lastX ;
F = G * x - b + fp * sinh( x(1:N) ) ;
dxSquared = 0 ;
relDiffSqX = 0 ;
normSqF = F.' * F ;

while ( iter < maxIter )
   delta = -fpinv * F ;
   Gdelta = G * delta ;
   Hprime = zeros(N, 1) ;

   % can this statement be vectorized like sinh( x(1:N) ) ?
   for i = 1:N
      Hprime(i) = fp * x(i) * cosh( x(i) ) ;
   end

   Fprime = Gdelta + Hprime ;

%disp( Gdelta.' * Fprime) ;
%disp( Gdelta ) ;
%disp( Fprime ) ;
   alpha = -(F.' * Fprime) / ( Gdelta.' * Fprime) ;

%   if ( ( 0 == mod(iter, 50) ) || (iter < 10) )
      disp( sprintf( '%d & %f & %f & %2.1e & %2.1e & %2.1e \\\\ \\hline', iter, alpha, max(abs(x)), norm(F), sqrt(dxSquared), sqrt(relDiffSqX) ) ) ;
%   end

   x = lastX + delta ;
%   x = lastX + alpha * delta ;

%disp( sprintf( '%d: x, H = ', iter ) ) ;
% x(0) ends up with 800, for which isinf( sinh(800) ) = 1.
%disp( x ) ;
   H = fp * sinh( x(1:N) ) ;
%disp( H ) ;
%disp( {'H', H} ) ;
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
