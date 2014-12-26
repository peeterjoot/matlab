function countItersAndPlot(showPlot)

ee = 1e-6 ;
maxiter = 500 ;

stepSize = [1 5] ;
%stepSize = [5] ;
%stepSize = [1] ;

nodamping = [1 0] ;
%nodamping = [0] ;
%nodamping = [1] ;

Vs = [1 10 20 100] ;
%Vs = [100] ;
%enableTrace() ;
disableTrace() ;

[fileExtension, savePlot] = saveHelper() ;

% | V | st1 nd | st2 nd | st1 w/d| st2 w/d |
c = 1 ;
out = '' ;
fignum = 1 ;
for V = Vs
   line = sprintf( '%d', V ) ;
   for nd = nodamping
      for s = stepSize
         [x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 500, s, nd ) ;
         y = [ -V;x;V ] ;

         line = sprintf( '%s & %d', line, r.totalIterations ) ;

         if ( showPlot )

            if ( nd )
               name = sprintf( 'ps2bP2PlotOfPsiV%dStepSize%dNoDampingFig%d.%s', V, s, fignum, fileExtension ) ;
            else
               name = sprintf( 'ps2bP2PlotOfPsiV%dStepSize%dWithDampingFig%d.%s', V, s, fignum, fileExtension ) ;
            end
            fignum = fignum + 1 ;

            f = plot( 0:r.deltaX:1, y ) ; xlabel( 'x' ) ; ylabel( '\psi(x)' ) ;
            savePlot( f, name ) ;
         end
      end
   end

   out = sprintf( '%s%s \\\\ \\hline\n', out, line ) ;
end

disp( out ) ;
