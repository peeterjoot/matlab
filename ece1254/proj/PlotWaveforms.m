function PlotWaveforms( p )
   % Calls the HBSolve function to solve the
   % circuit described in fileName using the Harmonic Balance method,
   % truncating the harmonics to N multiples of fundamental.
   % Various Parameters of interest are plotted

   if ( ~isfield( p, 'logPlot' ) )
      p.logPlot = 0 ;
   end

   if ( p.logPlot )
      cacheSuffix = 'TestSolver' ;
   else
      cacheSuffix = 'HBSolve' ;
   end

   cacheFile = sprintf( '%s%s.mat', p.figName, cacheSuffix ) ;

   if ( exist( cacheFile, 'file' ) )
      load( cacheFile ) ;
   else

      if ( p.logPlot )
         h = TestSolver( p.fileName ) ;

         save( cacheFile, 'h' ) ;
      else
         % Harmonic Balance Parameters
         N = 50 ;
         h = HBSolve( N, p.fileName ) ;

         % explicitly name the vars to avoid saving input param 'p'
         save( cacheFile, 'N', 'h' ) ;
      end
   end

%p
   if ( ~p.logPlot )

      v = h.v ;
      V = h.V ;
      R = h.R ;

      f0 = h.omega/( 2 * pi ) ;
      T = 1/f0 ;
      dt = T/( 2 * N + 1 ) ;
      k = -N:N ;
      t = dt*k ;

      % for Frequency Response
      fMHz = k*f0/1e6;

      numPlots = size( p.nPlus, 2 ) ;
   end

   if ( isfield( p, 'verbose' ) )
      h.xnames
   end

   fileExtension = 'pdf' ;
   %fileExtension = 'png' ;

   f = figure ;

   if ( ~isfield( p, 'spectrum' ) )
      p.spectrum = 0 ;
   end
   if ( ~isfield( p, 'legends' ) )
      p.legends = {} ;
   end
   if ( ~isfield( p, 'title' ) )
      p.title = '' ;
   end
   if ( ~isfield( p, 'figDesc' ) )
      p.figDesc = '' ;
   end

   if ( p.logPlot )

      loglog( h.Nvalues, h.errorValues, h.Nvalues, h.ecputimeValues, 'linewidth', 2 ) ;

   else
      for m = 1:numPlots
         hold on ;

         if ( p.spectrum )
            vd = abs( V( p.nPlus(m):R:end ) ) ;

            stem( fMHz, vd ) ;
         else
            if ( p.nPlus(m) && p.nMinus(m) )
               vd = real( v( p.nPlus(m):R:end ) ) - real( v( p.nMinus(m):R:end ) ) ;
            elseif ( p.nPlus(m) )
               vd = real( v( p.nPlus(m):R:end ) ) ;
            else
               vd = -real( v( p.nMinus(m):R:end ) ) ;
            end

            plot( t, vd, 'linewidth', 2 ) ;
         end
      end
   end
   if ( (size({}) ~= size( p.legends )) )
      legend( p.legends, 'Location', 'SouthEast' ) ;
   end

   xlabel( p.xLabel ) ;

   if ( isfield( p, 'yLabel' ) )
      ylabel( p.yLabel ) ;
   end

   if ( size( p.title, 2 ) )
      title( p.title ) ;
   end

   % eliminate the background that makes the saved plot look
   % like the GUI display window background color:
   set( f, 'Color', 'w' ) ;

   hold off ;

   saveName = sprintf( '%s%sFig%d.%s', p.figName, p.figDesc, p.figNum, fileExtension ) ;

   export_fig( saveName ) ;
end
