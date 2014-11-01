format short eng ;

netlistFileName = 'ps2a.1.netlist' ;

%Generate the modified nodal analysis equations
%Gx = b (1.1)
%for a grid with N = 40, R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.

generateResistorGridNetlist( netlistFileName, 40, 0.1, 1000000, 2, 0.1 ) ;

epsilon = eps( 1.0 ) * 100 ;

[G, b] = NodalAnalysis( netlistFileName ) ;

r = G\b ;

err = 1e-10 ;
enableTrace() ;
%s = conjugateGradientPainlessB2( G, b, [], err ) ;
%t = conjugateGradientPainlessB3( G, b, [], err ) ;
u = conjugateGradientQuarteroniPrecond( G, b, [], err ) ;
%N = size(G, 1) ;
%[v, relres, iter, flag] = conjgrad( G, b, b, eye(N), N, err ) ;

% compare direct solution with CG "solution".  None of these CG implementations converge.
[ norm( G * r - b ) ;
%  norm( G * s - b ) ;
%  norm( G * t - b ) ;
%  norm( G * v - b ) ;
  norm( G * u - b ) 
] 
