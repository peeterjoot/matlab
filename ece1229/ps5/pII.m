
   r = calculateZinAndStuff( 2 ) ;

   %------------------------------
   % (a)
   %
   % m->cm
   r.W

   %------------------------------
   % (b)
   %
   r.eEff

   %------------------------------
   % (c)
   %
   r.L0 

   %------------------------------
   % (d)
   % cm
   disp('L') ;
   r.L

   %------------------------------
   % (e)

   disp( 'k0 lambda0 G B Ys' ) ;
   r.k0
   r.lambda0
   r.G
   r.B
   r.Ys

   YsRadius = abs(r.Ys)
   YsDegrees = angle(r.Ys) * 180/pi

   %------------------------------
   % (f)
   %
   r.Zs
   ZsRadius = abs(r.Zs)
   ZsDegrees = angle(r.Zs) * 180 /pi
   r.beta

   r.Zin2
   Zin2Radius = abs(r.Zin2)
   Zin2Degrees = angle(r.Zin2) * 180 /pi

   r.Yin2
   Yin2Radius = abs(r.Yin2)
   Yin2Degrees = angle(r.Yin2) * 180 /pi

   %disp('hOverLambda0') ;
   %r.hOverLambda0

   %------------------------------
   % (g)
   %
   r.Ytotal
   r.Zin
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
