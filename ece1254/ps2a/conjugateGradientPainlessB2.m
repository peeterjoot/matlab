function [x, stats] = conjugateGradientPainlessB2( G, b, P, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.
% 
% This is based on the pseudocode algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.2
%
% It has been modified:
%
% - using a dumb and inefficient application of an 
%   optional preconditioner.
%
% - also modified to use the stop-iteration condition above.
% 

%enableTrace() ;
i = 0 ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conjugateGradientPainlessB2:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

x = rand(m, 1) ;

% optional preconditioning:
% A x = b
%  =>
% P^{-1/2} A P^{-1/2} (P^{1/2} x) = P^{-1/2} b
%
% solve:
% A' = P^{-1/2} A P^{-1/2}
% y = P^{1/2} x          ; x = P^{-1/2} y
% b' = P^{-1/2} b

if ( size(P, 1) ~= 0 )
   pHalfInverse = inv( sqrt( P ) ) ;

   G = pHalfInverse * G * pHalfInverse ;
   b = pHalfInverse * b ;
end

traceit( sprintf( 'N: %d', m ) ) ;

iMax = m ;
r = b - G * x ;
d = r ;
deltaNew = r.' * r ;
deltaNought = deltaNew ;
eSq = epsilon^2 ;
%iResetThresh = 50 ;
rSq = r.' * r ;
bSq = b.' * b ;
relativeErr = rSq/bSq ;
stats = [] ;

% B.2 convergence condition:
%while ( (i < iMax) && (deltaNew > (eSq * deltaNought)) )

% Assignment convergence condition:
while ( (i < iMax) && (relativeErr > epsilon) )
   q = G * d ;
   alpha = deltaNew/( d.' * q ) ;
   x = x + alpha * d ;

%   if ( mod( i, iResetThresh ) == 0 )
%      r = b - G * x ;
%   else
      r = r - alpha * q ;
%   end
   rSq = r.' * r ;
   relativeErr = rSq/bSq ;

   deltaOld = deltaNew ;
   deltaNew = r.' * r ;
   beta = deltaNew/deltaOld ;
   d = r + beta * d ;
   i = i + 1 ; 

%   if ( mod( i, 200 ) == 0 )
%      traceit( sprintf( '%d: deltaNew: %f, relErr: %f', i, deltaNew, relativeErr ) ) ;
%   end
end

if ( size(P, 1) ~= 0 )
   x = pHalfInverse * x ;
end

stats(end+1) = relativeErr ;
stats(end+1) = i ;
