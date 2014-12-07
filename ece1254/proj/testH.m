function testH(filename)

   [G, C, B, bdiode, angularVelocities, xnames] = NodalAnalysis( filename ) ;

   N = 1 ;
   % \nu = 7 is hardcoded in all these tests/*.netlist AC sources:
   omega = 2 * pi * 7 ;

%   xnames 

   [Y, Vnames, I, bdiode] = HarmonicBalance(G, C, B, bdiode, angularVelocities, xnames, N, omega) ;
%   [Y, B, I, angularVelocities, Vnames] 

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
