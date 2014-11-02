function compareBD()

netlistFileNameA = 'ps2a.1b.netlist' ;
netlistFileNameD = 'ps2a.1d.netlist' ;

%Generate the modified nodal analysis equations
%Gx = b (1.1)
%for a grid with N = 40, R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.
N=4 ;

generateResistorGridNetlist( netlistFileNameA, N, 0.1, 1000000, 2, 0.1, 1, 1 ) ;
generateResistorGridNetlist( netlistFileNameD, N, 0.1, 1000000, 2, 0.1, 0, 1 ) ;

[GV, bV] = NodalAnalysis( netlistFileNameA ) ;
[GI, bI] = NodalAnalysis( netlistFileNameD ) ;

save( 'norand.withV', 'GV', 'bV' ) ;

rV = GV\bV ;
rI = GI\bI ;

s = size(rV, 1) ;
rV = rV(1:s-2) ;
norm(rV - rI) 
