function plotFreqN500( )
% use PlotFreqResp to plot N=500 case 1, for part (c).

alpha = 0.01 ;
n = 500 ;
np1 = n + 1 ;
C = eye( np1 ) ;

B = zeros( np1, 1 ) ; % h(x = 0) = 1
B(1) = 1 ;
L = zeros( np1, 1 ) ;
L(n+1) = 1 ;

G = (alpha - n*n) * eye( np1 ) ;
G(1,1) = alpha ;
G(np1,np1) = alpha ;
G = G + 2 * n*n * diag( ones(1, n), -1 ) ;
G(2, 1) = n * n ;
G(n+1, n) = n * n ;
G = G - n*n * diag( ones(1, n-1), -2 ) ;

omega = logspace( -8, 4, n ) ;
[f1, f2] = PlotFreqResp( omega, G, C, B, L ) ;
