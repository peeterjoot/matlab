
   r = calculateZinAndStuff( 2 )

   YsRadius = abs(r.Ys) ;
   YsDegrees = angle(r.Ys) * 180/pi ;

   disp( sprintf('Y_s = %g /_ %g\n', YsRadius, YsDegrees ) ) ;

   %------------------------------
   % (f)
   %
   ZsRadius = abs(r.Zs) ;
   ZsDegrees = angle(r.Zs) * 180 /pi ;

   disp( sprintf('Z_s = %g /_ %g\n', ZsRadius, ZsDegrees ) ) ;

   Zin2Radius = abs(r.Zin2) ;
   Zin2Degrees = angle(r.Zin2) * 180 /pi ;

   disp( sprintf('Z_in2 = %g /_ %g\n', Zin2Radius, Zin2Degrees ) ) ;

   Yin2Radius = abs(r.Yin2) ;
   Yin2Degrees = angle(r.Yin2) * 180 /pi ;

   disp( sprintf('Y_in2 = %g /_ %g\n', Yin2Radius, Yin2Degrees ) ) ;

   %------------------------------
   % (g)
   %
   ZinRadius = abs(r.Zin) ;
   ZinDegrees = angle(r.Zin) * 180 /pi ;

   disp( sprintf('Z_in = %g /_ %g\n', ZinRadius, ZinDegrees ) ) ;

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
