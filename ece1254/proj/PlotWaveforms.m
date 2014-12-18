function PlotWaveforms( p )
   % Calls a Harmonic Balance solution function to solve the
   % circuit described in fileName using the Harmonic Balance method,
   % truncating the harmonics to N multiples of fundamental.
   % Various Parameters of interest are plotted

   if ( ~isfield( p, 'logPlot' ) )
      p.logPlot = 0 ;
   end

   if ( ~isfield( p, 'allowCaching' ) )
      p.allowCaching = 1 ;
   end

   if ( ~isfield( p, 'N' ) )
      p.N = 50 ; 
   end
   N = p.N ;

   if ( ~isfield( p, 'useBigF' ) )
      p.useBigF = 0 ;
   end

   if ( p.useBigF )
      currentCalculationMethodString = 'BigF' ;
   else
      currentCalculationMethodString = 'SmallF' ;
   end

   if ( p.logPlot )
      solutionMethodString = 'TimingAndError' ;
   else
      solutionMethodString = 'DirectSolution' ;
   end

   cacheFile = sprintf( '%s_%s_%s_N%d.mat', p.figName, solutionMethodString, currentCalculationMethodString, N ) ;
   traceit( sprintf( 'cacheFile: %s', cacheFile ) ) ;

   if ( exist( cacheFile, 'file' ) && p.allowCaching )
      load( cacheFile ) ;
   else

      if ( p.logPlot )
         h = TestSolver( p ) ;

         save( cacheFile, 'h' ) ;
      else
         % Harmonic Balance Parameters
         h = HBSolve( N, p ) ;

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

% FIXME: not returning this in all cases. (probably TestSolver)
%   if ( isfield( p, 'verbose' ) )
%      h.xnames
%   end

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

      loglog( h.Nvalues, h.errorValues, '-o', h.Nvalues, h.ecputimeValues, '-o', 'linewidth', 2 ) ;

      logN = log( h.Nvalues.' ) ;
      logErr = log( h.errorValues ) ;
      logCpu = log( h.ecputimeValues ) ;

      %plot( logN, logErr, '-o', logN, logCpu, '-o', 'linewidth', 2 ) ;

      pCpu = polyfit( logN, logCpu, 1 ) ;
      bCpu = pCpu(2) ;
      mCpu = pCpu(1) 

      % hack: bridge recitifier has -Inf error for the last N?
      pErr = polyfit( logN(1:end-1), logErr(1:end-1), 1 ) ;
      bErr = pErr(2) ;
      mErr = pErr(1) 

   else
      for m = 1:numPlots
         hold on ;

         if ( p.spectrum )
            vd = abs( V( p.nPlus(m):R:end ) ) ;

            stem( fMHz, vd, 'linewidth', 2 ) ;
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

   if ( exist( 'export_fig.m', 'file' ) )

      fileExtension = 'pdf' ;

      savePlot = @(f,n) export_fig( n ) ;

   elseif ( exist( 'plot2svg.m', 'file' ) )

      fileExtension = 'svg' ;

      savePlot = @(f,n) plot2svg( n ) ;
   else

      fileExtension = 'png' ;

      savePlot = @(f,n) saveas( f, n ) ;
   end

   saveName = sprintf( '%s%sFig%d.%s', p.figName, p.figDesc, p.figNum, fileExtension ) ;

   savePlot( f, saveName ) ;
end
