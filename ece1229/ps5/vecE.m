function determineEHplanes()
   % determineEHplanes: do a brute force numerical maximization of the E-field
   % to determine the E-plane and H-plane orientation.

   paramCacheFile = 'params.mat' ;

   if ( exist( paramCacheFile, 'file' ) )

      load( paramCacheFile ) ;

   else

      % parameters for part 3:
      a = 0.1 ;
      b = 0.1 ;
      f = 9.8e9 ;

      % $ c k = 2 \pi f $
      k = 2 * pi * f / 3e8 ;

      %rCap = @(t,p) [ sin(t) * cos(p) , sin(t) * sin(p) , cos(t) ] ;
      %thetaCap = @(t,p) [ cos(t) * cos(p) , cos(t) * sin(p) , -sin(t) ] ;
      %phiCap = @(t,p) [ -sin(p) , cos(p) , 0 ] ;

      X = @(t, p) k * sin(t) * cos(p) ;
      Y = @(t, p) k * sin(t) * sin(p) ;

      % $ \vec{E} = -\frac{j k}{r a \eta} e^{-j k r} ( \cos\theta \cos\phi \phicap + \sin\phi \thetacap ) \frac{ \cos( X a/2 ) }{ X^2 - (\pi/a)^2} \frac{ \sin( Y b/2 ) }{ Y/2}.$
      
      edir = @(t, p) (cos(t) * cos(p) * phicap(t, p) + sin(p) * thetacap(t, p)) ;
      hdir = @(t, p) (cos(t) * cos(p) * thetacap(t, p) - sin(p) * phicap(t, p)) ;

   %disp( phicap(0,0) ) 
   %disp( thetacap(0,0) ) 
   %edir(0,0)
      ee = @(t, p) edir(t,p) * (cos( X(t,p) * a / 2 )/(X(t,p)^2 - (pi/a)^2)) * (sin(Y(t,p)* b /2)/(Y(t,p)/2)) ;
   %disp(   ee(0,0) ) ;

      save( paramCacheFile ) ;
   fi

   maxE = -1.0 ;
   thetaAtMax = 0.0 ;
   phiAtMax = 0.0 ;
   ithetaAtMax = 0 ;
   iphiAtMax = 0 ;

   trange = 0:0.01:pi ;
   prange = 0:0.02:2 * pi ;

   rad = zeros( length(trange), length(prange) ) ;

   if ( 1 )
      % find the direction of the maximum field

      r = 1 ; 
      for t = trange
         s = 1 ; 
         for p = prange
            v = ee(t + 1e-10,p + 1e-10) ;
            n = norm( v ) ; 

            rad(r, s) = n ;

            if ( n > maxE )
               maxE = n ;
               thetaAtMax = t ;
               phiAtMax = p ;

               ithetaAtMax = r ;
               iphiAtMax = s ;
            end
            s = s + 1 ;
         end
         r = r + 1 ;
      end

      rad = rad/maxE ;

      % examining this data shows that we have the max at theta = 0 (for any phi), so we can 
      % pick phi=0 for simplicity.
      %
      % close all ; for i = 1:30:315 ; plot( trange, rad(:,i) ) ; hold on ; end
      % close all ; for i = 1:315 ; plot( trange, rad(:,i) ) ; hold on ; end
      % close all ; for i = 1:315 ; plot( prange, rad(i,:) ) ; hold on ; end
      % close all ; for i = 1:30:315 ; plot( prange, rad(i,:) ) ; hold on ; end
      % plot( prange, rad(1,:))

      % rcap(0,0) == zcap
      % edir(0,0) == ycap
      % hdir(0,0) == xcap

      % E-plane == y-z plane.  phi=pi/2
      % H-plane == z-x plane.  phi=0

      save('b.mat') ;
   else
      load('b.mat') ;
   end

   disp( sprintf('E_max(%g,%g)[%d,%d] = %g\n', thetaAtMax, phiAtMax, ithetaAtMax, iphiAtMax, maxE) ) ;
end
