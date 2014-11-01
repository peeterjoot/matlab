function x = conjugateGradientPainlessB3( G, b, P, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.
%
% This is based on the pseudocode algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.3
%
% (but modified to use the stop-iteration condition above).
%

%enableTrace() ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conjugateGradientPainlessB3:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

[mp, np] = size( P ) ;
x = rand(m, 1) ;

trace( sprintf( 'N: %d', m ) ) ;

% Algorithm from Shewchuk's
% "An Introduction to the Conjugate Gradient Method Without the Agonizing Pain"
% appendix B.3

i = 0 ;
iMax = m ;
r = b - G * x ;
if ( np ~= 0 )
   if ( (m ~= mp) || (n ~= np) )
      error( 'conjugateGradientPainlessB3:preconditionerCheck', 'preconditioning matrix dimensions %d,%d do not match input matrix dimensions %d,%d', mp, np, m, n ) ;
   end

   d = P\r ;
else
   d = r ;
end
deltaNew = r.' * d ;
deltaNought = deltaNew ;
%eSq = epsilon^2 ;
%iResetThresh = 50 ;
rSq = r.' * r ;
bSq = b.' * b ;
relativeErr = rSq/bSq ;

% B.3 convergence condition:
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

   if ( np ~= 0 )
      s = P\r ;
   else
      s = r ;
   end

   deltaOld = deltaNew ;
   deltaNew = r.' * s ;
   beta = deltaNew/deltaOld ;
   d = s + beta * d ;

   trace( sprintf( '%d: deltaNew: %f, relErr: %f, deltaNought: %f', i, deltaNew, relativeErr, deltaNought ) ) ;

   i = i + 1 ; 
end
