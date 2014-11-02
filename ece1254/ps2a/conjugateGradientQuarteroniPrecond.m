function [x, stats] = conjugateGradientQuarteroniPrecond( G, b, P, epsilon, withoutLU )
% write in MATLAB your own routine for the conjugate gradient method.
% Give to the user the possibility of specifying a preconditioning matrix P. 
% The routine shall stop iterations when the residual norm satisfies
%   \Norm{G x − b}^2/\Norm{b}^2 < epsilon
% where epsilon is a threshold specified by the user.
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
% parameters:
%  in/out: G x = b (returns x)
%  P (in): preconditioner
%  epsilon (in): see above.
%  withoutLU (optional: in): default is 1 (using solution with \ operator).  specify 0
%                            to do one time factorization to try to optimize the preconditioner
%                            application.
%

%enableTrace() ;
[m, n] = size( G ) ;

if ( n ~= m )
   error( 'conjugateGradientQuarteroniPrecond:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

[mp, np] = size( P ) ;
x = rand(m, 1) ;

%trace( sprintf( 'N: %d', m ) ) ;

i = 0 ;
iMax = m ;
if ( nargin < 5 )
   withoutLU = 1 ;
end

r = b - G * x ;
if ( np ~= 0 )
   if ( (m ~= mp) || (n ~= np) )
      error( 'conjugateGradientQuarteroniPrecond:preconditionerCheck', 'preconditioning matrix dimensions %d,%d do not match input matrix dimensions %d,%d', mp, np, m, n ) ;
   end

   if ( withoutLU ) 
      z = P\r ;
   else
      [ L, U, luP ] = lu( P ) ;
 
      Pr = luP * r ; 
      y = L\Pr ;
      z = U\y ;
   end
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
      if ( withoutLU ) 
         z = P\r ;
      else
         Pr = luP * r ; 
         y = L\Pr ;
         z = U\y ;
      end
   else
      z = r ;
   end

   deltaPrime = z.' * r ;
   beta = deltaPrime/delta ;
   delta = deltaPrime ;
   p = z + beta * p ;

%   if ( mod( i, 200 ) == 0 )
%   if ( mod( i, 50 ) == 0 )
%      stats(end+1) = relativeErr ;
%      trace( sprintf( '%d: delta: %f, relErr: %f', i, delta, relativeErr ) ) ;
%   end

   i = i + 1 ; 
end

stats(end+1) = relativeErr ;
stats(end+1) = i ;
