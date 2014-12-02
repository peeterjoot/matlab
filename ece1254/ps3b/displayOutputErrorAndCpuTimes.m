function displayOutputErrorAndCpuTimes()

   qs = [1 2 4 10 50 501] ;

   tmax = [ 10000 700 ] ;   
   withSine = [ 1 0 ] ;
   names = { 'Sine', 'Unit' } ;

   for ii = 1:2
      f = figure ;

      [discreteTimes, ~, s, ~] = calculateSolutionForTimestep( 501, 2000, tmax(ii), 0, withSine(ii) ) ;
      [~, ~, sq1, ~] = calculateSolutionForTimestep( 1, 2000, tmax(ii), 0, withSine(ii) ) ;
      [~, ~, sq50, ~] = calculateSolutionForTimestep( 50, 2000, tmax(ii), 0, withSine(ii) ) ;
      hold on ;
      plot( discreteTimes, s - sq1) ;
      plot( discreteTimes, s - sq50) ;
      xlabel( 't [s]' ) ;
      ylabel( 'Temp [C]' ) ;
      legend( { 'y(t) - y_{q = 1}(t)', 'y(t) - y_{q = 50}(t)'} ) ;
      hold off ;

      saveas( f, sprintf( 'ps3b%sDriverErrorFig1.png', names{ii} ) ) ;

      f = figure ;
      plot( discreteTimes, s ) ;
      xlabel( 't [s]' ) ;
      ylabel( 'y(t) [C]' ) ;

      saveas( f, sprintf( 'ps3b%sDriverOutputFig1.png', names{ii} ) ) ;

      f = figure ;
      hold on ;

      jj = 1 ;
      cpuAverages = zeros( size(qs) ) ;
      cpuDeviations = cpuAverages ;
      for q = qs
         [~, ~, ~, iterationTimes] = calculateSolutionForTimestep( q, 2000, tmax(ii), 0, withSine(ii) ) ;

         average = mean( iterationTimes ) ;
         cpuAverages(jj) = average ;
         cpuDeviations(jj) = std( iterationTimes, 1 ) ;
         text( log10(q), average, sprintf('%d', q), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right' ) ;

         jj = jj + 1 ;
      end

      logQ = log10(qs) ;
      errorbar( logQ, cpuAverages, cpuDeviations, '-ob' ) ;
      xlabel( 'log_{10}(q)' ) ;
      ylabel( 'cpu time [s]' ) ;

      hold off ;
      saveas( f, sprintf( 'ps3b%sDriverCpuTimesFig1.png', names{ii} ) ) ;
   end





% not interesting to plot more than one... no visible differences for any q (even q = 1, vs 501).
   if ( 0 )
      figure ;

      for q = [1 501]
% 0.01 t = 2 pi  ; t = 200 pi
         [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, 2000, 10000, 0, 1 ) ;
         hold on ;
         if ( q == 1 )
            plot( discreteTimes, v ) ;
         end
         plot( discreteTimes, s ) ;
      end
      plotFreqPartC.m:   legend( {'y(t), q = 1', 'y(t)'} ) ;

      figure ;

      for q = [1 501]
         [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, 2000, 700, 0, 0 ) ;
         hold on ;
         plot( discreteTimes, s ) ;
      end
      legend
      plotFreqPartC.m:   legend( {'y(t), q = 1', 'y(t)'} ) ;
      hold off ;
   end
end
