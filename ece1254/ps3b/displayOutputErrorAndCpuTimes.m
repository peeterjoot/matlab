function tableData = displayOutputErrorAndCpuTimes()

   indexColumnDone = 0 ;

   methodNames = { 'modal', 'prima' } ;

   qs = [1 2 4 10 50 501] ;

   tmax = [ 10000 700 ] ;   
   withSine = [ 1 0 ] ;
   names = { 'Sine', 'Unit' } ;

   tableData = {} ;

   %for withPrima = 1:1 
   for withPrima = 0:1 

      if ( withPrima )
         qo = 2 ;
      else
         qo = 50 ;
      end

      for ii = 1:2 % sine vs unit
         f = figure ;

         [discreteTimes, ~, s, ~] = calculateSolutionForTimestep( 501, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;
         [~, ~, sq1, ~] = calculateSolutionForTimestep( 1, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;
         [~, ~, sqO, ~] = calculateSolutionForTimestep( qo, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;
         hold on ;
         plot( discreteTimes, s - sq1) ;
         plot( discreteTimes, s - sqO) ;
         xlabel( 't [s]' ) ;
         ylabel( 'Temp [C]' ) ;
         legend( { 'y(t) - y_{q = 1}(t)', sprintf('y(t) - y_{q = %d}(t)', qo) } ) ;
         hold off ;

         saveas( f, sprintf( 'ps3b%sDriverError%sFig1.png', names{ii}, methodNames{withPrima+1} ) ) ;

         f = figure ;
         plot( discreteTimes, s ) ;
         xlabel( 't [s]' ) ;
         ylabel( 'y(t) [C]' ) ;

         saveas( f, sprintf( 'ps3b%sDriverOutput%sFig1.png', names{ii}, methodNames{withPrima+1} ) ) ;

         f = figure ;
         hold on ;

         jj = 1 ;
         cpuAverages = zeros( size(qs) ) ;
         cpuDeviations = cpuAverages ;
         for q = qs
            [~, ~, ~, iterationTimes] = calculateSolutionForTimestep( q, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;

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
         saveas( f, sprintf( 'ps3b%sDriverCpuTimes%sFig1.png', names{ii}, methodNames{withPrima+1} ) ) ;

         cpuColumn = {} ;         
         indexColumn = {} ;         
         errorColumn = {} ;         

         cpuColumn{end+1} = sprintf('%s, cpu, %s', methodNames{withPrima+1}, names{ii}) ;
         errorColumn{end+1} = sprintf('%s, error, %s', methodNames{withPrima+1}, names{ii}) ;
         indexColumn{end+1} = 'q' ;
         [~, ~, sRef, itRef] = calculateSolutionForTimestep( 501, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;

         % construct a table of cpu times and absolute errors
         for q = [1 2 4 10 50]

            [~, ~, s, it] = calculateSolutionForTimestep( q, 2000, tmax(ii), 0, withSine(ii), withPrima ) ;

            maxErr = max(abs(sRef - s)) ;
            meanCpu = mean(it) ;
            devCpu = std(it, 1) ;
    
            errorColumn{end+1} = sprintf('%1.2e', maxErr ) ; 
            cpuColumn{end+1} = sprintf('%1.2e \\pm %1.2e', meanCpu, devCpu ) ; 
            indexColumn{end+1} = sprintf('%d', q) ;
         end

         if ( ~indexColumnDone )
            indexColumnDone = 1 ;

            tableData{end+1} = indexColumn ;
         end

         tableData{:, end+1} = errorColumn ;
         tableData{:, end+1} = cpuColumn ;
      end % </ii>
   end % </withPrima>

   disp( tableData ) ;
   % for i = 1:size(t, 2) ; for j = 1:size(t{1}, 2) ; disp(t{i}{j}) ; end ; end
   % rough tabularization (required too much post processing)
   %for j = 1:size(t{1}, 2) ; for i = 1:size(t, 2) ; disp(t{i}{j}) ; disp '&' ; end ; end

end % </function>

%      % for modal (and prima), not interesting to plot more than one... no visible differences for any q (even q = 1, vs 501).
%      if ( 0 )
%         for q = qs
%            [discreteTimes, ~, s, ~] = calculateSolutionForTimestep( q, 2000, 10000, 0, 1, withPrima ) ;
%            %hold on ;
%
%            figure ;
%            plot( discreteTimes, s ) ;
%            title( sprintf( 'q = %d', q ) ) ;
%         end
%
%         figure ;
%
%         for q = qs
%            [discreteTimes, ~, s, ~] = calculateSolutionForTimestep( q, 2000, 700, 0, 0, withPrima ) ;
%            %hold on ;
%
%            figure ;
%            plot( discreteTimes, s ) ;
%            title( sprintf( 'q = %d', q ) ) ;
%         end
%         %hold off ;
%      end
