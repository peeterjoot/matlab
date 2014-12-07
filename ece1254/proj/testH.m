function testH( filename )

   [G, C, B, bdiode, u, xnames] = NodalAnalysis( filename ) ;

   N = 1 ;
   omega = 2 ;

%   xnames 

   [Y, B, I, u, Vnames] = HarmonicBalance(G, C, B, bdiode, u, xnames, N, omega) ;

disp( 'G, C, Ry, Ri:' ) ;
   G
   C
   real(Y)
   imag(Y)
%   Vnames
%   B   

end   
