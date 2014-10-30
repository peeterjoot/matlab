function x = conjugateGradientPainlessB2( G, b, P, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.
% 
% This directly uses the algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.2
%
% It has been modified by using a dumb and inefficient application of an optional
% preconditioner.
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

trace( sprintf( 'N: %d', m ) ) ;

iMax = m ;
r = b - G * x ;
d = r ;
deltaNew = r.' * r ;
deltaNought = deltaNew ;
eSq = epsilon^2 ;
iResetThresh = 50 ;

while ( (i < iMax) && (deltaNew > (eSq * deltaNought)) )
   q = G * d ;
   alpha = deltaNew/( d.' * q ) ;
   x = x + alpha * d ;

   if ( mod( i, iResetThresh ) == 0 )
      r = b - G * x ;
   else
      r = r - alpha * q ;
   end

   deltaOld = deltaNew ;
   deltaNew = r.' * r ;
   beta = deltaNew/deltaOld ;
   d = r + beta * d ;
   i = i + 1 ; 
end

if ( size(P, 1) ~= 0 )
   x = pHalfInverse * x ;
end

trace( sprintf( 'deltaNew: %f, deltaNought: %f, i: %d', deltaNew, deltaNought, i ) ) ;
