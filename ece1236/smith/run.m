
% can run this in the matlab UI with 'run' ... it pulls in the whole file and all it's commands.
%function run()

   f = figure();

   # run make to copy over the export_fig stuff.
   [fileExtension, savePlot] = saveHelper() ;

   %http://www.mathworks.com/matlabcentral/fileexchange/1923-smith-chart-plot/content//plotSmithChart.m
   plotSmithChart() ;

   savePlot( f, sprintf( 'smithchartFig1.%s', fileExtension ) ) ;
   saveas( f, sprintf( 'smithchartFig1.%s', 'png' ) ) ;

%return
