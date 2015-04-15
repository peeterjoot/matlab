function r = calculateZinAndStuff( p, m )
   % calculateZinAndStuff: given input value of m, calculate Z_in and other stuff

   %------------------------------
   % (d)
   %
   % cm
   L = p.L0 - m * p.deltaL ;

   %------------------------------
   % (e)
   %
   k0h = p.k0 * p.h ;

   G = (p.W/(120 * p.lambda0)) * ( 1 - (1/24)* k0h^2 ) ;
   B = (p.W/(120 * p.lambda0)) * ( 1 - 0.636 * log( k0h )) ;

   Ys = G + 1j * B ;

   %------------------------------
   % (f)
   %
   Zs = 1/Ys ;
   beta = p.k0 * sqrt( p.eEff ) ;

   Zin2 = p.Z0 * (Zs + 1j * p.Z0 * tan( beta * L ))/(p.Z0 + 1j * Zs * tan( beta * L )) ;

   Yin2 = 1/Zin2  ;

   %------------------------------
   % (g)
   %
   Ytotal = Yin2 + Ys ;
   Zin = 1/Ytotal ;

   r = struct( 'L', L, ...
               'G', G, ...
               'B', B, ...
               'Ys', Ys, ...
               'beta', beta, ...
               'Zs', Zs, ...
               'Zin2', Zin2, ...
               'Yin2', Yin2, ...
               'Ytotal', Ytotal, ...
               'Zin', Zin ) ;
end
