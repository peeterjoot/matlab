function [x, stats] = conjugateGradientQuarteroniPrecond( G, b, P, epsilon )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < e
% where e is a threshold specified by the user.
%
% This is based on the algorithm from Quarteroni, et al's "Numerical Mathematics"
% 
% That text also has a Matlab implementation for this algorithm (copied into conjgrad.m
% for reference and to compare test results from).
%
% This matlab routine was coded using the algorithm but not using the explicit listing.  The
% change of variables used to go from the algorthim to this routine are listed in the
% problem set writup.
%

%enableTrace() ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conjugateGradientQuarteroniPrecond:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

[mp, np] = size( P ) ;
x = rand(m, 1) ;

trace( sprintf( 'N: %d', m ) ) ;

i = 0 ;
iMax = m ;

r = b - G * x ;
if ( np ~= 0 )
   if ( (m ~= mp) || (n ~= np) )
      error( 'conjugateGradientQuarteroniPrecond:preconditionerCheck', 'preconditioning matrix dimensions %d,%d do not match input matrix dimensions %d,%d', mp, np, m, n ) ;
   end

   z = P\r ;
else
   z = r ;
end
p = z ;
delta = z.' * r ;
rSq = r.' * r ;
bSq = b.' * b ;
relativeErr = rSq/bSq ;
stats = [] ;

while ( (i < iMax) && (relativeErr > epsilon) )
   q = G * p ;
   alpha = delta/( p.' * q ) ;
   x = x + alpha * p ;

%   if ( mod( i, iResetThresh ) == 0 )
%      r = b - G * x ;
%   else
      r = r - alpha * q ;
%   end
   rSq = r.' * r ;
   relativeErr = rSq/bSq ;

   if ( np ~= 0 )
      z = P\r ;
   else
      z = r ;
   end

   deltaPrime = z.' * r ;
   beta = deltaPrime/delta ;
   delta = deltaPrime ;
   p = z + beta * p ;

%   if ( mod( i, 200 ) == 0 )
   if ( mod( i, 50 ) == 0 )
      stats(end+1) = relativeErr ;
      trace( sprintf( '%d: delta: %f, relErr: %f', i, delta, relativeErr ) ) ;
   end

   i = i + 1 ; 
end
