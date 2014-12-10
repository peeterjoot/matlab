function PlotWaveforms( fileName, saveBaseName, withTitle )
   % Calls the HBSolve function to solve the
   % circuit described in fileName using the Harmonic Balance method,
   % truncating the harmonics to N multiples of fundamental.
   % Various Parameters of interest are plotted

   %clear
   %clc
   if ( nargin < 1 )
      fileName = '../circuits/BridgeRectifier.netlist' ;
   end

   if ( nargin < 3 )
      withTitle = 0 ;
   end

   % Harmonic Balance Parameters
   N = 50 ;
   [x, X, ecputime, omega, R ] = HBSolve( N, fileName ) ;

   f0 = omega/( 2*pi ) ;
   T = 1/f0 ;
   dt = T/( 2*N+1 ) ;
   k = -N:N ;
   t = dt*k ;

   % Plot Voltages
   v1 = real( x( 1:R:end ) ) ;
   v2 = real( x( 2:R:end ) ) ;
   v3 = real( x( 3:R:end ) ) ;
   % v4 = real( x( 4:M:end ) ) ;
   % v5 = real( x( 5:M:end ) ) ;
   %
   i = real( x( 4:R:end ) ) ;
   vr = v3 ;
   close all ;

   figNum = 2 ;
   f = figure ;
   plot( t, v2-v1, t, vr, 'linewidth', 2 ) ;
   legend( 'Source Voltage', 'Output Voltage', 4 ) ;
   xlabel( 'Time (s)' ) ;
   ylabel( 'Voltage (V)' ) ;
   setFigureProperties( f ) ;

   if ( nargin == 2 )
      saveName = sprintf( '%sOutputVoltageFig%d', saveBaseName, figNum ) ;
      saveas( f, saveName, 'eps' ) ;
      %plot2svg( saveName, f ) ;

      figNum = figNum + 1 ;
   end

   %
   f = figure ;
   plot( t, i, 'linewidth', 2 ) ;
   if ( withTitle )
      title( 'Source Current' ) ;
   end
   xlabel( 'Time (s)' ) ;
   ylabel( 'Current (A)' ) ;
   setFigureProperties( f ) ;

   if ( nargin == 2 )
      saveName = sprintf( '%sSourceCurrentFig%d', saveBaseName, figNum ) ;
      saveas( f, saveName, 'eps' ) ;
      %plot2svg( saveName, f ) ;

      figNum = figNum + 1 ;
   end



   vd1 = v2 - v3 ;
   vd2 = -v1 ;
   vd3 = v1 - v3 ;
   vd4 = -v2 ;

   f = figure ;
   plot( t, vd1, t, vd2, t, vd3, t, vd4, 'linewidth', 2 ) ;
   if ( withTitle )
      title( 'Diode Voltages' ) ;
   end
   legend( 'vd1', 'vd2', 'vd3', 'vd4', 4 ) ;
   xlabel( 'Time (s)' ) ;
   ylabel( 'Voltage (V)' ) ;
   setFigureProperties( f ) ;

   if ( nargin == 2 )
      saveName = sprintf( '%sDiodeVoltagesFig%d', saveBaseName, figNum ) ;
      saveas( f, saveName, 'eps' ) ;
      %plot2svg( saveName, f ) ;

      figNum = figNum + 1 ;
   end
end
