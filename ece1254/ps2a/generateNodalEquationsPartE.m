function generateNodalEquationsPartE()

netlistFileName = 'tmp.netlist' ;

%Generate the modified nodal analysis equations
%G x = b
%for a grid with R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.

R = 0.1 ;
Rg = 1000000 ;
Vs = 2 ;
Rs = 0.1 ;
withVoltage = 0 ;

N = [ 4 8 16 32 64 128 192 ] ;
for i = N
   generateResistorGridNetlist( netlistFileName, i, R, Rg, Vs, Rs, withVoltage ) ;

   [G, b] = NodalAnalysis( netlistFileName ) ;
   G = sparse( G ) ; % save, taking less space.

   savename = sprintf( 'nodal.%d.mat', i ) ;
   disp( savename )

   save( savename, 'G', 'b' ) ;
end
