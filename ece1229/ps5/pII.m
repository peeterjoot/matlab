   f0 = 10e9 ; % 1/s
   er = 2.2 ; % dimensionless
   c = 3e8 ; % m/s 
   cmInMeter = 100 ;

   h = 0.1588 ; % cm

   lambda0 = cmInMeter * c/f0 ;
   Z0 = 26 ;
   k0 = 2 * pi/ lambda0 ;

   hOverLambda0 = h / lambda0

   p = struct( 'f0', f0, ...
               'er', er, ...
               'k0', k0, ...
               'c', c, ...
               'cmInMeter', cmInMeter, ...
               'h', h, ...
               'lambda0', lambda0, ...
               'Z0', Z0 ) 

   r = calculateZinAndStuff( p, 2 ) 

   displayAsPhasor = @(l,V) disp( sprintf('%s = %g /_ %g\n', l, abs(V), angle(V) * 180/pi ) ) ;

   displayAsPhasor( 'Y_s', r.Ys ) ;

   %------------------------------
   % (f)
   %
   displayAsPhasor( 'Z_s', r.Zs ) ;
   displayAsPhasor( 'Z_in2', r.Zin2 ) ;
   displayAsPhasor( 'Y_in2', r.Yin2 ) ;

   %------------------------------
   % (g)
   %
   displayAsPhasor( 'Z_in', r.Zin ) ;

   %------------------------------
   % (h)
   %
   m = 0:0.1:3 ;
   zz = zeros(size(m)) ;
   k = 1 ;
   for i = m
      r = calculateZinAndStuff( p, i ) ;
      zz(k) = r.Zin ;
      k = k + 1 ;
   end
   close all ;
if ( 0 )
   plot( m, imag(zz) ) ;
end

   findzeros = @(a) find( diff( sign( diff( a ) ) ) == 2 ) + 1 ;

   zpos = findzeros( abs(imag(zz)) ) ;

   zero = m(zpos)

   % refine a bit:

   m = -0.1 + zero : 0.0001 : 0.1 + zero ;
   zz = zeros(size(m)) ;
   k = 1 ;
   for i = m
      r = calculateZinAndStuff( p, i ) ;
      zz(k) = r.Zin ;
      k = k + 1 ;
   end
%   close all ;
%   plot( m, imag(zz) ) ;

   zpos = findzeros( abs(imag(zz)) ) ;

   zero = m(zpos)

% Could refine a bit more, but this is a dumb way to do it.
% If I wanted a better answer should use a narrowing search algorithm, or 
% just do it analytically.
if ( 0 )

   m = -0.01 + zero : 0.00001 : 0.01 + zero ;
   zz = zeros(size(m)) ;
   k = 1 ;
   for i = m
      r = calculateZinAndStuff( p, i ) ;
      zz(k) = r.Zin ;
      k = k + 1 ;
   end
%   close all ;
%   plot( m, imag(zz) ) ;

   zpos = findzeros( abs(imag(zz)) ) ;

   zero = m(zpos)
end

   r = calculateZinAndStuff( p, zero ) 

   displayAsPhasor( 'Z_in,new', r.Zin ) ;
