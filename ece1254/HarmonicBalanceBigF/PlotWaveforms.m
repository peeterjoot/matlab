function PlotWaveforms( p )
   % Calls the HBSolve function to solve the
   % circuit described in fileName using the Harmonic Balance method,
   % truncating the harmonics to N multiples of fundamental.
   % Various Parameters of interest are plotted

   cacheFile = sprintf( '%s.mat', p.figName ) ;

   if ( exist( cacheFile, 'file' ) )
      load( cacheFile ) ;
   else

      % Harmonic Balance Parameters
      N = 50 ;
      h = HBSolve( N, p.fileName ) ;

      % explicitly name the vars to avoid saving input param 'p'
      save( cacheFile, 'N', 'h' ) ;
   end

   if ( isfield( p, 'verbose' ) )
      h.xnames
   end

   x = h.x ;
   X = h.X ;
   R = h.R ;

   fileExtension = 'pdf' ;
   %fileExtension = 'png' ;

   f0 = h.omega/( 2 * pi ) ;
   T = 1/f0 ;
   dt = T/( 2 * N + 1 ) ;
   k = -N:N ;
   t = dt*k ;

   % for Frequency Response
   fMHz = k*f0/1e6;

   numPlots = size( p.nPlus, 2 ) ;

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

   for m = 1:numPlots
      hold on ;

      if ( p.spectrum )
         v = abs( X( p.nPlus(m):R:end ) ) ;

         stem( fMHz, v ) ;
      else
         if ( p.nPlus(m) && p.nMinus(m) )
            v = real( x( p.nPlus(m):R:end ) ) - real( x( p.nMinus(m):R:end ) ) ;
         elseif ( p.nPlus(m) )
            v = real( x( p.nPlus(m):R:end ) ) ;
         else
            v = -real( x( p.nMinus(m):R:end ) ) ;
         end

         plot( t, v, 'linewidth', 2 ) ;
      end
   end
   if ( (size({}) ~= size( p.legends )) )
      legend( p.legends, 'Location', 'SouthEast' ) ;
   end

   xlabel( p.xLabel ) ;
   ylabel( p.yLabel ) ;

   if ( size( p.title, 2 ) )
      title( p.title ) ;
   end

   setFigureProperties( f ) ;
   hold off ;

   saveName = sprintf( '%s%sFig%d.%s', p.figName, p.figDesc, p.figNum, fileExtension ) ;

   export_fig( saveName ) ;
end
