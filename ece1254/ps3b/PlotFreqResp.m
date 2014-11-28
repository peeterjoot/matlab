function [f1, f2] = PlotFreqResp(omegaSet,G,C,B,L)
% A Matlab routine PlotFreqResp(omegaSet,G,C,B,L) which takes in omegaSet, G,C, B, L as input and
% plots the system frequency response. Here omegaSet is a vector of frequencies in rad/s.
% 
% This is a plot of:
%
% F(s) = L^T ( G + s C )^{-1} B U(s)
% 
% for a impulse response (U(s) is all ones)

bSize = size( B, 2 ) ;
u = ones( bSize, 1 ) ;

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
%disp(GsC) ;
   x = GsC\bu ;

   f = lt * x ;

   response(end+1) = f ; 
end

f1 = figure ;
plot( omegaSet, real(response), '-.ob' ) ;
legend( {'Real'} ) ;
xlabel( '\omega' ) ;

f2 = figure ;
plot( omegaSet, imag(response), '-.ob' ) ;
xlabel( '\omega' ) ;
legend( {'Imag'} ) ;

%legend( {'Real', 'Imag'} ) ;
