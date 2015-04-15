

%function pII()
   % pII: docs go here.

   f0 = 10e9 ; % 1/s
   er = 2.2 ; % dimensionless
   c = 3e8 ; % m/s 
   cmInMeter = 100 ;

   h = 0.1588 ; % cm

   %------------------------------
   % (a)
   %
   % m->cm
   W = sqrt(2/(1 + er)) * (c/(2 * f0)) * cmInMeter

   %------------------------------
   % (b)
   %
   eEff = (er + 1)/2 + (er - 1)/2/sqrt(1 + 12 * h/W) 

   %------------------------------
   % (c)
   %
   % m->cm
   L0 = cmInMeter * c/(2 * f0) / sqrt(eEff)

   %------------------------------
   % (d)
   %
   % dimensionless
   deltaLoverH = 0.412 * ( eEff + 0.3 ) * ( W/h + 0.264 )/( (eEff - 0.258) * (W/h + 0.8) )

   % cm
   deltaL = deltaLoverH * h

   % cm
   L = L0 - 2 * deltaL 

   %------------------------------
   % (e)
   %
   k0 = pi/L0
   lambda0 = 2 * L0

   G = (W/(120 * lambda0)) * ( 1 - (k0 * h)^2/24)
   B = (W/(120 * lambda0)) * ( 1 - 0.636 * log(k0 * h))

   Ys = G + 1j * B
   YsRadius = abs(Ys)
   YsDegrees = angle(Ys) * 180/pi

   %------------------------------
   % (f)
   %
   Zs = 1/Ys
   ZsRadius = abs(Zs)
   ZsDegrees = angle(Zs) * 180 /pi
   Z0 = 26 ;
   beta = k0 * sqrt( eEff )

   Zin2 = Z0 * (Zs + 1j * Z0 * tan( beta * L ))/(Z0 + 1j * Zs * tan( beta * L ))
   Zin2Radius = abs(Zin2)
   Zin2Degrees = angle(Zin2) * 180 /pi

   Yin2 = 1/Zin2 
   Yin2Radius = abs(Yin2)
   Yin2Degrees = angle(Yin2) * 180 /pi
%end
