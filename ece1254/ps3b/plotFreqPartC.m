function plotFreqPartC( n, where )
% pass 500,1 to use PlotFreqResp to plot N=500 case 1, for part (c).

alpha = 0.01 ;
netlist = 'a.netlist' ;

L = zeros( n + 3, 1 ) ;
L(where) = 1 ;
if ( (where > (n+3)) || (where < 1) )
   error( 'plotFreqPartC:where', 'value for where (%d) not in range', where ) ;
end

generateNetlist( netlist, n, alpha ) ;

[G, C, B, xnames] = NodalAnalysis( netlist, 1 ) ;

if ( n <= 10 )
%   traceit( sprintf('G, C, B\n%s\n%s\n%s\n', mat2str( G ), mat2str( C ), mat2str( B ) ) ) ;
   disp( G ) ;
   disp( C ) ;
   disp( B ) ;
   disp( xnames ) ;
end

omega = logspace( -8, 4, n ) ;
f = PlotFreqResp( omega, G, C, B, L ) ;
saveas( f, 'ps3bFreqResponsePartCFig1.png' ) ;
