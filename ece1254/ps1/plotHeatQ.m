function plotHeatQ( n, doProblemA, withSine, figdesc )
% plot the netlist results for ps1 p3b, and p3d.
%
% For details see the ps1 pdf.
%
   filename = 'heat.netlist' ;

   if ( nargin < 4 )
      figdesc = 'FigXX' ;
   end

   generateHeatNetlist( filename, n, doProblemA, withSine ) ;

   [G, b] = NodalAnalysis( filename ) ;

%   disp(G) ;
%   disp(b) ;
   x = G\b ;
   t = x( 1:n ) ;

   deltaX = 1/(n-1) ;

   xi = 0:deltaX:1 ;

disp('min, max:') ;
min(t)
max(t)

   f = figure ;

   [fileExtension, savePlot] = saveHelper() ;

   plot( xi, t ) ;

   savePlot( f, sprintf( '%sn%d.%s', figdesc, n, fileExtension ) ) ;
end
