function [fileExtension, savePlot] = saveHelper()
   % choose how to plot, depending on the save'ing functions available.

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
end
