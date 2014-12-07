function foo()

   [G, C, B, bdiode, u, xnames] = NodalAnalysis('tests/ac.netlist') ;

   N = 1 ;
   omega = 2 ;

   G
   C
%   xnames 

   [Y, B, I, u, Vnames] = HarmonicBalance(G, C, B, bdiode, u, xnames, N, omega) ;

   real(Y)
   imag(Y)
   Vnames
%   B   

end   
