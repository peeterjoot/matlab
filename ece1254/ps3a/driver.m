function driver( what, withBE )
%
% parameters:
% (1) what:
%
% if what == 1: error/cpu plots
%    what == 2: doMultiPlot
% else
%             : single plot (\delta t = 5 ps)
% (2) withBE == 1, plot for BE.  NA if what == 1.

withTR = ~withBE ;
if ( withBE )
   methodStr = 'BE' ;
else
   methodStr = 'TR' ;
end

if ( what == 1 )

   [t, v, sTR1, cpuTR1] = calculateSolutionForTimestep( 0.001, 0 ) ;
   [tx, v, sBE1, cpuBE1] = calculateSolutionForTimestep( 0.001, 1 ) ;
   [tx, v, sTR5, cpuTR5] = calculateSolutionForTimestep( 0.005, 0 ) ;
   [tx, v, sBE5, cpuBE5] = calculateSolutionForTimestep( 0.005, 1 ) ;
   [tx, v, sTR10, cpuTR10] = calculateSolutionForTimestep( 0.01, 0 ) ;
   [tx, v, sBE10, cpuBE10] = calculateSolutionForTimestep( 0.01, 1 ) ;
   [tx, v, sTR50, cpuTR50] = calculateSolutionForTimestep( 0.05, 0 ) ;
   [tx, v, sBE50, cpuBE50] = calculateSolutionForTimestep( 0.05, 1 ) ;

   sBE5 = interpolate( sBE5, 0.005e-9, 0.001e-9, 5e-9 ) ;
   sTR5 = interpolate( sTR5, 0.005e-9, 0.001e-9, 5e-9 ) ;
   sBE10 = interpolate( sBE10, 0.01e-9, 0.001e-9, 5e-9 ) ;
   sTR10 = interpolate( sTR10, 0.01e-9, 0.001e-9, 5e-9 ) ;
   sBE50 = interpolate( sBE50, 0.05e-9, 0.001e-9, 5e-9 ) ;
   sTR50 = interpolate( sTR50, 0.05e-9, 0.001e-9, 5e-9 ) ;

   dBE1 = sBE1 - sTR1 ;
   dBE5 = sBE5 - sTR1 ;
   dTR5 = sTR5 - sTR1 ;
   dBE10 = sBE10 - sTR1 ;
   dTR10 = sTR10 - sTR1 ;
   dBE50 = sBE50 - sTR1 ;
   dTR50 = sTR50 - sTR1 ;

   % table of errors:
   e = [ max(abs(dBE1)) ;
         max(abs(dBE5)) ;
         max(abs(dBE10)) ;
         max(abs(dBE50)) ;
         max(abs(dTR5)) ;
         max(abs(dTR10)) ;
         max(abs(dTR50)) ] ;
   n = { 'BE, 1 ps' ;
         'BE, 5 ps' ;
         'BE, 10 ps' ;
         'BE, 50 ps' ;
         'TR, 5 ps' ;
         'TR, 10 ps' ;
         'TR, 50 ps' ; } ;
   % took three sample times for each measurement.  use the min of each to minimize external-to-matlab cpu load dependent effects.
   c = [ min(cpuBE1) ;
         min(cpuBE5) ;
         min(cpuBE10) ;
         min(cpuBE50) ;
         min(cpuTR5) ;
         min(cpuTR10) ;
         min(cpuTR50) ] ;
   s = [ std(cpuBE1, 1) ;
         std(cpuBE5, 1) ;
         std(cpuBE10, 1) ;
         std(cpuBE50, 1) ;
         std(cpuTR5, 1) ;
         std(cpuTR10, 1) ;
         std(cpuTR50, 1) ] ;
   { n, e, c, s }

   if ( 1 )
      f = figure ;
      hold on ;

      labels = { } ;
      p = [] ;
      p(end+1) = plot( t, dBE1 ) ; labels{end+1} = sprintf( 'BE, \\Delta t = 1 ps' ) ;
      p(end+1) = plot( t, dBE5 ) ; labels{end+1} = sprintf( 'BE, \\Delta t = 5 ps' ) ;
      p(end+1) = plot( t, dBE10 ) ; labels{end+1} = sprintf( 'BE, \\Delta t = 10 ps' ) ;
      p(end+1) = plot( t, dBE50 ) ; labels{end+1} = sprintf( 'BE, \\Delta t = 50 ps' ) ;

      xlabel( 'time (s)' ) ;
      ylabel( 'Voltages (V)' ) ;
      legend( labels ) ;
      savePath = sprintf( 'ps3a%sFig%d.png', 'ErrorBE', 5 ) ;
      saveas( f, savePath ) ;
   end

   if ( 1 )
      f2 = figure ;
      hold on ;

      labels = { } ;
      p = [] ;
      p(end+1) = plot( t, sTR5 - sTR1 ) ; labels{end+1} = sprintf( 'TR, \\Delta t = 5 ps' ) ;
      p(end+1) = plot( t, sTR10 - sTR1 ) ; labels{end+1} = sprintf( 'TR, \\Delta t = 10 ps' ) ;
      p(end+1) = plot( t, sTR50 - sTR1 ) ; labels{end+1} = sprintf( 'TR, \\Delta t = 50 ps' ) ;

      xlabel( 'time (s)' ) ;
      ylabel( 'Voltages (V)' ) ;
      legend( labels ) ;

      savePath = sprintf( 'ps3a%sFig%d.png', 'ErrorTR', 6 ) ;
      saveas( f2, savePath ) ;
   end

   if ( 1 )
      f3 = figure ;
      eBE = e(1:4) ;
      tBE = [ 1 ; 5 ; 10 ; 50 ] ;
      eTR = e(5:7) ;
      tTR = [ 5 ; 10 ; 50 ] ;

      if ( 1 )
         logtBE = log(tBE) ;
         logeBE = log(eBE) ;
         logtTR = log(tTR) ;
         logeTR = log(eTR) ;

         % loglog() output is confusing.
         plot( logtBE, logeBE, '-.ob' ) ;
         hold on ;
         plot( logtTR, logeTR, '-.xr' ) ;
         xlabel( 'Log timestep (ps)' ) ;
         ylabel( 'Log Error (V)' ) ;
         legend( {'BE', 'TR'} ) ;

         pBE = polyfit( logtBE, logeBE, 1 ) ;
         bBE = pBE(2)
         mBE = pBE(1)

         pTR = polyfit( logtTR, logeTR, 1 ) ;
         bTR = pTR(2)
         mTR = pTR(1)

      else
         loglog( tBE, eBE, '-.ob' ) ;
         hold on ;
         loglog( tTR, eTR, '-.xr' ) ;
         xlabel( 'timestep (ps)' ) ;
         ylabel( 'Error (V)' ) ;
      end
      legend( {'BE', 'TR'} ) ;

      savePath = sprintf( 'ps3a%sFig%d.png', 'LogLogError', 7 ) ;
      saveas( f3, savePath ) ;
   end

elseif ( what == 2 )
   f = figure ;
   hold on ;

   labels = { 'v_{clk}' } ;
   p = [] ;
   [t, v, s, cpu] = calculateSolutionForTimestep( 0.05, withBE ) ;
   p(end+1) = plot( t, v ) ;
   p(end+1) = plot( t, s ) ;
   labels = { 'v_{clk}' } ;
   labels{end+1} = sprintf( '%s, \\Delta t = 50 ps', methodStr ) ;

   [t, v, s, cpu] = calculateSolutionForTimestep( 0.01, withBE ) ;
   p(end+1) = plot( t, s ) ;
   labels{end+1} = sprintf( '%s, \\Delta t = 10 ps', methodStr ) ;

   [t, v, s, cpu] = calculateSolutionForTimestep( 0.005, withBE ) ;
   p(end+1) = plot( t, s ) ;
   labels{end+1} = sprintf( '%s, \\Delta t = 5 ps', methodStr ) ;

   [t, v, s, cpu] = calculateSolutionForTimestep( 0.001, withBE ) ;
   p(end+1) = plot( t, s ) ;
   labels{end+1} = sprintf( '%s, \\Delta t = 1 ps', methodStr ) ;

   xlabel( 'time (s)' ) ;
   ylabel( 'Voltages (V)' ) ;
   legend( labels ) ;

   savePath = sprintf( 'ps3a%sFig%d.png', methodStr, 2 + withTR * 2 ) ;
   saveas( f, savePath ) ;
else
   f = figure ;
   hold on ;

   [t, v, s, cpu] = calculateSolutionForTimestep( 0.005, withBE ) ;
   labels = { 'v_{clk}' } ;
   p = [] ;
   p(end+1) = plot( t, v ) ;
   p(end+1) = plot( t, s ) ;
   labels{end+1} = sprintf( '%s, \\Delta t = 5 ps', methodStr ) ;

   xlabel( 'time (s)' ) ;
   ylabel( 'Voltages (V)' ) ;
   legend( labels ) ;

   savePath = sprintf( 'ps3a%sFig%d.png', methodStr, 1 + withTR * 2 ) ;
   saveas( f, savePath ) ;
end

hold off ;
