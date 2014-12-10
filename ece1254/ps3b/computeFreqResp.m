function response = computeFreqResp( omegaSet, G, C, B, L )
% A Matlab routine computeFreqResp( omegaSet, G, C, B, L ) which takes in omegaSet, G, C, B, L as input and
% produces data for system frequency response plots. Here omegaSet is a vector of frequencies in rad/s.
%
% This is a plot of:
%
% F(s) = L^T ( G + s C )^{-1} B U(s)
%
% for a impulse response (U(s) is all ones)

bSize = size( B, 2 ) ;
%u = ones( bSize, 1 ) ;
u = zeros( bSize, 1 ) ;
u(1) = 1 ;

bu = B * u ;
lt = L.' ;

response = [] ;

for omega = omegaSet
   traceit( sprintf('omega = %e', omega ) ) ;
   s = i * omega ;

% with:
%   ( G + s C )^{-1} bu = x
%   bu = (G + s C) x
%   x = ( G + s C)\bu ;

   GsC = G + s * C ;
   x = GsC\bu ;

   f = lt * x ;

   response(end+1) = f ;
end
