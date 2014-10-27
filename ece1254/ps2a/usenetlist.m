format short eng ;

netlistFileName = 'ps2a.1.netlist' ;

%Generate the modified nodal analysis equations
%Gx = b (1.1)
%for a grid with N = 40, R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.

%generateResistorGridNetlist(filename, N, R, Rg, Vs, Rs)
generateResistorGridNetlist( netlistFileName, 40, 0.1, 1000000, 2, 0.1 ) ;

epsilon = eps( 1.0 ) * 100 ;

[G, b] = NodalAnalysis( netlistFileName ) ;

