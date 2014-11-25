function driver( doMultiPlot )

if ( doMultiPlot )
   savepath = 'ps3aBEFig2.png' ;
%   savepath = '../../../figures/ece1254/ps3aBEFig2.png' ;

   labels = {} ;
   [p, f, lt] = plotSolutionIterations( 0.05, 1 ) ;
   labels{end+1} = lt(1) ;
   labels{end+1} = lt(2) ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.01, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt(1) ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.005, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt(1) ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.001, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt(1) ;

% get 'Cell array argument must be a cell array of strings.' :
%   disp( labels ) ;
%'v_{chip}'    'v_{clk} (\Delta ...'    {1x1 cell}    {1x1 cell}    {1x1 cell}
%legend({'v_{clk}', 'v_{chip} (ts = 50 ps)', 'v_{chip} (ts = 10 ps)', 'v_{chip} (ts = 5 ps)', 'v_{chip} (ts = 1 ps)'}) ;
else
   [p, f, labels] = plotSolutionIterations( 0.005, 1 ) ;

   savepath = 'ps3aBEFig1.png' ;
%   savepath = '../../../figures/ece1254/ps3aBEFig1.png' ;
end

xlabel( 'time (s)' ) ;
ylabel( 'Voltage (V)' ) ;
legend( labels ) ;

hold off ;

if ( ~exist( savepath, 'file' ) )
   saveas( f, savepath ) ;
end
