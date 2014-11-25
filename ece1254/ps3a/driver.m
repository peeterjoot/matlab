function driver( doMultiPlot, withBE )

withTR = ~withBE ;

%if ( withFigure )
%   f = figure ;
%   hold on ;
%else
%   f = 0 ;
%end
%
%p = [] ;
%labels = {} ;
%
%if ( withFigure )
%   data = timeseries( v, discreteTimes ) ;
%   p( end + 1 ) = plot( data ) ;
%end

data = timeseries( s, discreteTimes ) ;
p( end + 1 ) = plot( data ) ;
if ( withBE )
   thisLabel = sprintf( 'v_{clk} (BE, \\Delta t = %d ps)', 1000 * deltaTinNanoseconds ) ;
else
   thisLabel = sprintf( 'v_{clk} (TR, \\Delta t = %d ps)', 1000 * deltaTinNanoseconds ) ;
end
if ( 1 )
   labels = { 'v_{chip}' } ;

   [p, f, lt, s] = plotSolutionIterations( 0.001, 1, 0 ) ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt, s] = plotSolutionIterations( 0.001, 0, 1 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;
elseif ( doMultiPlot )
   savePath = sprintf( 'ps3aBEFig%d.png', 2 + withTR * 2 ) ;

   labels = { 'v_{chip}' } ;
   [p, f, lt, s] = plotSolutionIterations( 0.05, 1, withBE ) ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt, s] = plotSolutionIterations( 0.01, 0, withBE ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt, s] = plotSolutionIterations( 0.005, 0, withBE ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt, s] = plotSolutionIterations( 0.001, 0, withBE ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

else
   [p, f, thisLabel, s] = plotSolutionIterations( 0.005, 1, withBE ) ;
   labels = { 'v_{chip}', thisLabel } ;

   savePath = sprintf( 'ps3aBEFig%d.png', 1 + withTR * 2 ) ;
end

xlabel( 'time (s)' ) ;
ylabel( 'Voltage (V)' ) ;
legend( labels ) ;

hold off ;

%if ( ~exist( savePath, 'file' ) )
%   saveas( f, savePath ) ;
%end
