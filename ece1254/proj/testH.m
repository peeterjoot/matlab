function testH(filename)

   [G, C, B, bdiode, angularVelocities, xnames] = NodalAnalysis( filename ) ;

   N = 1 ;
   omega = 2 ;

%   xnames 

   [Y, Vnames, I, bdiode] = HarmonicBalance(G, C, B, bdiode, angularVelocities, xnames, N, omega) ;
%   [Y, B, I, angularVelocities, Vnames] 

disp( 'G, C, Yr, Yi:, Ir, Ii' ) ;
   G
   C
   real(Y)
   imag(Y)
   real(I)
   imag(I)
   Vnames

end   
