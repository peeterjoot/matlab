function testH(filename)

   [G, C, B, angularVelocities, D, bdiode, xnames] = NodalAnalysis( filename ) ;

   N = 1 ;
   % \nu = 7 is hardcoded in all these tests/*.netlist AC sources:
   omega = 2 * pi * 7 ;

%   xnames 

   [Y, Vnames, I] = HarmonicBalance(G, C, B, angularVelocities, D, bdiode, xnames, N, omega) ;

disp( 'G, C, B, omegas, Yr, Yi:, Ir, Ii' ) ;
   G
   C
   B
   angularVelocities
   real(Y)
   imag(Y)
   real(I)
   imag(I)
   Vnames

end   
