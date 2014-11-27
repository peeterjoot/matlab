function testPlotFreqResp( n )
% test PlotFreqResp

C = eye( n ) ;
t = tridiagonal( rand(n) ) ;
G = t + t.' ;
B = 3 * eye( n ) ;
Lt = zeros( 1, n ) ;
Lt(1) = 1 ;

f = PlotFreqResp( 0:50, G, C, B, Lt.' ) ;
