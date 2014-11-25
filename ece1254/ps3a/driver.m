function driver( doMultiPlot )

if ( doMultiPlot )
   savepath = 'ps3aBEFig2.png' ;
%   savepath = '../../../figures/ece1254/ps3aBEFig2.png' ;

   [p, f, labels] = plotSolutionIterations( 0.05, 1 ) ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.01, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.005, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

   [pt, fIgnore, lt] = plotSolutionIterations( 0.001, 0 ) ;
   p(end+1) = pt ;
   labels{end+1} = lt ;

else
   [p, f, labels] = plotSolutionIterations( 0.005, 1 ) ;

   savepath = 'ps3aBEFig1.png' ;
%   savepath = '../../../figures/ece1254/ps3aBEFig1.png' ;
end

xlabel( 'time (s)' ) ;
ylabel( 'Voltage (V)' ) ;
legend( labels ) ;
% get 'Cell array argument must be a cell array of strings.' ... not sure what happened.  used to fix:
%legend({'v_{clk}', 'v_{chip} (ts = 50 ps)', 'v_{chip} (ts = 10 ps)', 'v_{chip} (ts = 5 ps)', 'v_{chip} (ts = 1 ps)'}) ;

hold off ;

if ( ~exist( savepath, 'file' ) )
   saveas( f, savepath ) ;
end
