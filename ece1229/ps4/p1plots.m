function p1plots( saveEmToo )
   % plots: ps4. p1: generate and save the plots for each of the desired values of: a d

   adValues = 0 : pi/2 : 3 * pi/2 ;
   labelValues = { '0', '90', '180', '270' } ;

   [fileExtension, savePlot] = saveHelper() ;

   figNum = 1 ;
   for ad = adValues
      f = p1plot( ad ) ;

      if ( saveEmToo )
         saveName = sprintf( 'ps4p1PlotAdEquals%sDegreesFig%d.%s', labelValues{figNum}, figNum, fileExtension ) ;

         savePlot( f, saveName ) ;

         figNum = figNum + 1 ;
      end
   end
end
