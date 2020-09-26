function generateNodalEquationsPartEH(partE)

netlistFileName = 'tmp.netlist' ;

%Generate the modified nodal analysis equations
%G x = b
%for a grid with R = 0.1Ω, R g = 1MΩ,V s = 2V, R s = 0.1Ω.

R = 0.1 ;
Rg = 1000000 ;
Vs = 2 ;
Rs = 0.1 ;
withVoltage = 0 ;

if ( partE )
   N = [ 4 8 16 32 64 128 192 ] ;
   for i = N
      generateResistorGridNetlist( netlistFileName, i, R, Rg, Vs, Rs, withVoltage ) ;

      [G, b] = NodalAnalysis( netlistFileName ) ;
      G = sparse( G ) ; % save, taking less space.

      savename = sprintf( 'nodal.%d.mat', i ) ;
      disp( savename )

      save( savename, 'G', 'b' ) ;
   end
else
   N = 20 ;
   R = [ 0.1 1 10 ] ;

   for r = R
      generateResistorGridNetlist( netlistFileName, N, r, Rg, Vs, Rs, withVoltage ) ;

      [G, b] = NodalAnalysis( netlistFileName ) ;
      G = sparse( G ) ; % save, taking less space.

      savename = sprintf( 'nodal.N%d.R%d.mat', N, r ) ;
      disp( savename )

      save( savename, 'G', 'b' ) ;
   end
end
