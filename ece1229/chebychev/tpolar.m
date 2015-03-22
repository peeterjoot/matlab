[fileExtension, savePlot] = saveHelper() ;

saveName = sprintf( 'PolarFig%d.%s', 1, fileExtension ) ;

%theta = 0:0.01:2*pi ;
theta = -pi:0.01:pi ;
%rho = sin(2 * theta) .* cos( 2 * theta ) ;
rho = cos( theta ) ;

%f = figure ;

polar( theta, rho ) ;

%savePlot( f, saveName ) ;
