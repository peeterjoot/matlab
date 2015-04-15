
   r = calculateZinAndStuff( 2 )

   YsRadius = abs(r.Ys)
   YsDegrees = angle(r.Ys) * 180/pi

   %------------------------------
   % (f)
   %
   ZsRadius = abs(r.Zs)
   ZsDegrees = angle(r.Zs) * 180 /pi

   Zin2Radius = abs(r.Zin2)
   Zin2Degrees = angle(r.Zin2) * 180 /pi

   Yin2Radius = abs(r.Yin2)
   Yin2Degrees = angle(r.Yin2) * 180 /pi

   %------------------------------
   % (g)
   %
   ZinRadius = abs(r.Zin)
   ZinDegrees = angle(r.Zin) * 180 /pi

   %------------------------------
   % (h)
   %
   m = 0:0.01:3 ;
   zz = zeros(size(m)) ;
   k = 1 ;
   for i = m
      r = calculateZinAndStuff( i ) ;
      zz(k) = r.Zin ;
      k = k + 1 ;
   end
   close all ;
   plot( m, imag(zz) ) ;
