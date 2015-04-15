function r = calculateZinAndStuff( p, m )
   % calculateZinAndStuff: given input value of m, calculate Z_in and other stuff

   %------------------------------
   % (a)
   %
   % (cm units because lambda0 is)
   W = sqrt(2/(1 + p.er)) * (p.lambda0/2) ;

   %------------------------------
   % (b)
   %
   eEff = (p.er + 1)/2 + (p.er - 1)/2/sqrt(1 + 12 * p.h/W) ;

   %------------------------------
   % (c)
   %
   % (cm units because lambda0 is)
   L0 = ( p.lambda0/2 ) / sqrt(eEff) ;

   %------------------------------
   % (d)
   %
   % dimensionless
   deltaLoverH = 0.412 * ( eEff + 0.3 ) * ( W/p.h + 0.264 )/( (eEff - 0.258) * (W/p.h + 0.8) ) ;

   % cm
   deltaL = deltaLoverH * p.h ;

   % cm
   L = L0 - m * deltaL ;

   %------------------------------
   % (e)
   %
   k0h = p.k0 * p.h ;

   G = (W/(120 * p.lambda0)) * ( 1 - (1/24)* k0h^2 ) ;
   B = (W/(120 * p.lambda0)) * ( 1 - 0.636 * log( k0h )) ;

   Ys = G + 1j * B ;

   %------------------------------
   % (f)
   %
   Zs = 1/Ys ;
   beta = p.k0 * sqrt( eEff ) ;

   Zin2 = p.Z0 * (Zs + 1j * p.Z0 * tan( beta * L ))/(p.Z0 + 1j * Zs * tan( beta * L )) ;

   Yin2 = 1/Zin2  ;

   %------------------------------
   % (g)
   %
   Ytotal = Yin2 + Ys ;
   Zin = 1/Ytotal ;

   r = struct( 'W', W, ...
               'eEff', eEff, ...
               'L0', L0, ...
               'L', L, ...
               'deltaL', deltaL, ...
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
