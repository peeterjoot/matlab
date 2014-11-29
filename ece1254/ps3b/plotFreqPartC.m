function plotFreqPartC( n, where )
% pass 500,1 to use PlotFreqResp to plot N=500 case 1, for part (c).

alpha = 0.01 ;
np1 = n + 1 ;
C = eye( np1 ) ;

B = zeros( np1, 1 ) ; % h(x = 0) = 1
B(1) = -1 ;
L = zeros( np1, 1 ) ;
L(where) = 1 ;

G = (alpha + 2 * n) * eye( np1 ) - n * ( diag( ones(1, n), -1 ) + diag( ones(1, n), 1 ) ) ;

G(1,1) = alpha ;
G(np1,np1) = alpha ;

G(1, 1) = alpha ;
%G(2, 1) = 0 ;
%G(1, 2) = 0 ;

%G(n+1, n) = 0 ;
%G(n, n+1) = 0 ;
G(n+1, n+1) = alpha ;

G(2, 2) = alpha + n ;
G(n, n) = alpha + n ;

if ( n <= 10 )
   disp(G) ;
end

omega = logspace( -8, 4, n ) ;
f = PlotFreqResp( omega, G, C, B, L ) ;
%saveas( f, 'ps3bFreqResponsePartCFig1.png' ) ;
