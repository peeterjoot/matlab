function x = conjugateGradientWithPreconditioner( G, b, P, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.

%enableTrace() ;
i = 0 ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conjugateGradientWithPreconditioner:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

[mp, np] = size( P ) ;
if ( (m ~= mp) || (n ~= np) )
   error( 'conjugateGradientWithPreconditioner:preconditionerCheck', 'preconditioning matrix dimensions %d,%d do not match input matrix dimensions %d,%d', mp, np, m, n ) ;
end

x = rand(m, 1) ;

trace( sprintf( 'N: %d', m ) ) ;

% Algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.3

iMax = m ;
r = b - G * x ;
%Inv = inv( P ) ;
pInv = P ;
d = pInv * r ;
deltaNew = r.' * d ;
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

   s = pInv * r ;
   deltaOld = deltaNew ;
   deltaNew = r.' * s ;
   beta = deltaNew/deltaOld ;
   d = r + beta * d ;
   i = i + 1 ; 
end

trace( sprintf( 'deltaNew: %f, deltaNought: %f, i: %d', deltaNew, deltaNought, i ) ) ;
