function PlotFreqResp( omegaSet, G, C, B, L )
% A Matlab routine PlotFreqResp( omegaSet, G, C, B, L ) which takes in omegaSet, G, C, B, L as input and
% plots the system frequency response. Here omegaSet is a vector of frequencies in rad/s.
% 
% This is a plot of:
%
% F(s) = L^T ( G + s C )^{-1} B U(s)
% 
% for a impulse response (U(s) is all ones)

response = computeFreqResp( omegaSet, G, C, B, L ) ;

f = figure ;
pReal = semilogx( omegaSet, real(response), 'b' ) ;
xlabel( '\omega' ) ;
hold on ;
pImag = semilogx( omegaSet, imag(response), 'r' ) ;
legend( {'Real', 'Imag'} ) ;
hold off ;
