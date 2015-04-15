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
   % brute force way, but gives a plot as a side effect
   m = 0:0.1:3 ;
   zz = zeros(size(m)) ;
   k = 1 ;
   for i = m
      r = calculateZinAndStuff( p, i ) ;
      zz(k) = r.Zin ;
      k = k + 1 ;
   end
   close all ;
   f = plot( m, imag(zz) ) ;
   xlabel( 'm' ) ;
   ylabel( 'Im(Z_{in})' ) ;

   [fileExtension, savePlot] = saveHelper() ;
   saveName = sprintf( 'imagZinFig%d.%s', 6, fileExtension ) ;
   savePlot( f, saveName ) ;

   findzeros = @(a) find( diff( sign( diff( a ) ) ) == 2 ) + 1 ;

   zpos = findzeros( abs(imag(zz)) ) ;
   zero = m(zpos)

   % refine (could also do this on the 0:3 interval)
   minm = zero-0.1 ;
   maxm = zero+0.1 ;
   %r = calculateZinAndStuff( p, minm )
   %r = calculateZinAndStuff( p, maxm )

   maxIter = 20 ;   
   for i = 0:maxIter
      midm = (maxm + minm)/2 ;

      r = calculateZinAndStuff( p, midm ) ;

      if ( imag(r.Zin) > 0 )
         maxm = midm ;
      else
         minm = midm ;
      end

%      disp( [ imag(r.Zin), minm, midm, maxm ] ) ;
   end

   disp( sprintf( '%g\n', midm ) ) ;

   r.Zin
%   r = calculateZinAndStuff( p, midm ) 

   displayAsPhasor( 'Z_in,new', r.Zin ) ;
