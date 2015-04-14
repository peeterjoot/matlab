function determineEHplanes()
   % determineEHplanes: do a brute force numerical maximization of the E-field
   % to determine the E-plane and H-plane orientation.

   paramCacheFile = 'params.mat' ;

   % construct the electric field function:
   if ( exist( paramCacheFile, 'file' ) )

      load( paramCacheFile ) ;

   else

      % parameters for part 3:
      a = 0.1 ;
      b = 0.1 ;
      f = 9.8e9 ;

      % $ c k = 2 \pi f $
      k = 2 * pi * f / 3e8 ;

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
   end

   maxE = -1.0 ;
   thetaAtMax = 0.0 ;
   phiAtMax = 0.0 ;
   ithetaAtMax = 0 ;
   iphiAtMax = 0 ;

   trange = linspace( 0, pi, 300 ) ;
   prange = linspace( 0, 2 * pi, 300 ) ;

   rad = zeros( length(trange), length(prange) ) ;

   %
   % precompute the magnitude of the field in all the various directions (used
   % to find the zeros, 3dB point, and sidelobe levels)
   %
   radCacheFile = 'rad.mat' ;
   if ( exist( radCacheFile, 'file' ) )

      load( radCacheFile ) ;

   else
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

      disp( sprintf('E_max(%g,%g)[%d,%d] = %g\n', thetaAtMax, phiAtMax, ithetaAtMax, iphiAtMax, maxE) ) ;
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

      save( radCacheFile ) ;
   end

   eplane = rad(:,1) ;
   hplane = rad(:, floor(length(prange)/4)) ; % 2 pi / 4 = pi/2

   de = diff(eplane) ;
   dh = diff(hplane) ;

   showPlots = 1 ;
   if ( showPlots )
      [fileExtension, savePlot] = saveHelper() ;
      close all ;
      fe = figure ;
      plot( trange, eplane )
      xlabel( '\theta' )

      piGradientTicks = 1 ;

      if ( piGradientTicks )
         xlim([0 pi()])
         % Set axis gca's Xtick and XtickLabel to manually input data
         set(gca, 'XTick',[0,0.25*pi,.5*pi,0.75*pi,pi]);
         set(gca,'XTickLabel',{'0','\pi/4','\pi/2','3 \pi/4','\pi'});
      end

      % show the adjacent differences, and their signs to visualize the null-search:
      if ( 0 )
         hold on ;
         plot( trange(1:length(de)), de )
         plot( trange(1:length(de)), sign(de) )
      end

      saveName = sprintf( 'eplaneFig%d.%s', 2, fileExtension ) ;
      savePlot( fe, saveName ) ;

      fh = figure ;
      plot( trange, hplane )
      xlabel( '\theta' )

      if ( piGradientTicks )
         xlim([0 pi()])
         % Set axis gca's Xtick and XtickLabel to manually input data
         set(gca, 'XTick',[0,0.25*pi,.5*pi,0.75*pi,pi]);
         set(gca,'XTickLabel',{'0','\pi/4','\pi/2','3 \pi/4','\pi'});
      end

      % show the adjacent differences, and their signs to visualize the null-search:
      if ( 0 )
         hold on ;
         plot( trange(1:length(dh)), dh )
         plot( trange(1:length(dh)), sign(dh) )
      end

      saveName = sprintf( 'hplaneFig%d.%s', 3, fileExtension ) ;
      savePlot( fh, saveName ) ;
   end

   % http://stackoverflow.com/a/29607885/189270
   findzeros = @(a) find( diff( sign( diff( a ) ) ) == 2 ) + 1 ;
   findlevels = @(a) find( diff( sign( diff( a ) ) ) == -2 ) + 1 ;
   ze = findzeros( eplane ) ;
   zh = findzeros( hplane ) ;
   le = findlevels( eplane ) ;
   lh = findlevels( hplane ) ;

%   disp( findzeros( eplane ) ) ;
%   disp( findzeros( hplane ) ) ;
%   disp( trange( ze ) ) ;
%   disp( trange( zh ) ) ;

   disp( 'zeros' ) ;
   disp( trange( ze ) * 180 / pi ) ;
   disp( trange( zh ) * 180 / pi ) ;

   disp( 'peaks (rad)' ) ;
   disp( trange( le ) ) ;
   disp( trange( lh ) ) ;
   disp( 'peaks (degrees)' ) ;
   disp( trange( le ) * 180 / pi ) ;
   disp( trange( lh ) * 180 / pi ) ;
   disp( 'peaks (levels)' ) ;
   disp( eplane( le ) ) ;
   disp( hplane( lh ) ) ;
   disp( 'peak levels power, (dB)' ) ;
   disp( 10 * log10(eplane( le ).^2) ) ;
   disp( 10 * log10(hplane( lh ).^2) ) ;

   threeDbThresh = 10^(-3/20) ;
   disp( '3 dB point (rad)' ) ;
   threeDbPtE = findzeros( abs(eplane - threeDbThresh) ) ;
   threeDbPtH = findzeros( abs(hplane - threeDbThresh) ) ;
   threeDbPtE = threeDbPtE(1) ;
   threeDbPtH = threeDbPtH(1) ;
   disp( trange( threeDbPtE ) ) ;
   disp( trange( threeDbPtH ) ) ;
   disp( '3 dB point (degrees)' ) ;
   disp( trange( threeDbPtE ) * 180 / pi ) ;
   disp( trange( threeDbPtH ) * 180 / pi ) ;
   disp( '3 dB level (field)' ) ;
   disp( eplane( threeDbPtE ) ) ;
   disp( hplane( threeDbPtH ) ) ;
   disp( '[check] 3 dB power level, (dB)' ) ;
   disp( 10 * log10(eplane( threeDbPtE ).^2) ) ;
   disp( 10 * log10(hplane( threeDbPtH ).^2) ) ;

   polarPlots = 1 ;
   if ( showPlots && polarPlots )
      f3 = figure ;
      logpolar( trange, logscale( eplane.^2, -50 ).' )
      saveName = sprintf( 'eplanePolarFig%d.%s', 4, fileExtension ) ;
      savePlot( f3, saveName ) ;

      f4 = figure ;
      logpolar( trange, logscale( hplane.^2, -50 ).' )
      saveName = sprintf( 'hplanePolarFig%d.%s', 5, fileExtension ) ;
      savePlot( f4, saveName ) ;
   end

%   save('c.mat') ;
end
