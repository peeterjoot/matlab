function norms = usenetlistProblemBD(withVoltageSource)
% Write a small matlab function that generates a netlist for a network made by:

% format short eng ;

if ( withVoltageSource )
   netlistFileName = 'ps2a.1b.netlist' ;
else
   netlistFileName = 'ps2a.1d.netlist' ;
end

%Generate the modified nodal analysis equations
%Gx = b (1.1)
%for a grid with N = 40, R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.

generateResistorGridNetlist( netlistFileName, 40, 0.1, 1000000, 2, 0.1, 0 ) ;

[G, b] = NodalAnalysis( netlistFileName ) ;

r = G\b ;

err = 1e-10 ;
enableTrace() ;
s = conjugateGradientQuarteroniPrecond( G, b, [], err ) ;
disableTrace() ;

t = conjugateGradientPainlessB2( G, b, [], err ) ;
u = conjugateGradientPainlessB3( G, b, [], err ) ;
N = size(G, 1) ;
[v, relres, iter, flag] = conjgrad( G, b, b, eye(N), N, err ) ;

% compare direct solution with CG "solution".  None of these CG implementations converge.
norms = [ norm( G * r - b ) 
; norm( G * s - b ) 
; norm( G * t - b ) 
; norm( G * u - b ) 
; norm( G * v - b ) 
] ;
