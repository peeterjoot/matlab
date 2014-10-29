function x = conguateGradient( G, b, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.

i = 0 ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conguateGradient:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

x = rand(m, 1) ;

% Algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.2

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
