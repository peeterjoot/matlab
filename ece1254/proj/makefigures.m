function makefigures()

   %clear
   %clc
   close all ;

   doAll  = 0 ;
   doAll2 = 0 ;
   doAll3 = 0 ;

   [fileExtension, savePlot] = saveHelper() ;

   if ( doAll || 0 )
      p = struct( 'fileName', '../circuits/BridgeRectifier.netlist' ) ;
      p.figName = 'bridgeRectifier' ;

      p.figNum = 5 ;
      p.logPlot = 1 ;
      %p.verbose = 1 ;
      p.figDesc = 'ErrorAndCpuTimes' ;
      p.title = 'Error and CPU times' ;
      p.legends = { 'Normalized Error', 'CPU Time' } ;
      p.xLabel = 'N (Number of Harmonics)' ;
      PlotWaveforms( p ) ;

      %p.N = 3 ;
      p.logPlot = 0 ;
      p.xLabel = 'Time (s)' ;
      %p.useBigF = 0 ;

      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;

      p.nPlus = [ 2 3 ] ;
      p.nMinus = [ 1 0 ] ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      p.figNum = 3 ;
      p.figDesc = 'SourceCurrent' ;
      p.title = 'Source Current' ;
      p.nPlus = 4 ;
      p.nMinus = 0 ;
      p.legends = {} ;
      p.yLabel = 'Current (A)' ;
      PlotWaveforms( p ) ;

      %p.allowCaching = 0 ;
      p.figDesc = 'DiodeVoltages' ;
      p.title = 'Diode Voltages' ;
      p.figNum = 4 ;
      p.nPlus = [ 2 0 1 0 ] ;
      p.nMinus = [ 3 1 3 2 ] ;
      p.legends = { 'vd1', 'vd2', 'vd3', 'vd4' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;
   end

   if ( doAll || 0 )
      p = struct( 'fileName', '../circuits/BridgeRectifierPow.netlist' ) ;
      p.figName = 'bridgeRectifierPow' ;
      p.xLabel = 'Time (s)' ;
      %p.allowCaching = 0 ;
      p.useBigF = 0 ; % can't use BigF method for this circuit.
      %p.minStep = 1e-6 ;
      %p.dlambda = 0.001 ;
      p.iterations = 100 ;
      %p.verbose = 1 ;

      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;

      p.nPlus = [ 2 3 ] ;
      p.nMinus = [ 1 0 ] ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;
   end

   if ( doAll || 0 )
      p = struct( 'fileName', '../circuits/BridgeRectifierCap.netlist' ) ;
      p.figName = 'bridgeRectifierCapFilter' ;
      p.xLabel = 'Time (s)' ;

% for omega_0 lowering experiment
%      p.N = 100 ;
%      p.dlambda = 0.005 ;
%      p.iterations = 200 ;
%      p.JcondTol = 1e-21 ;
%      p.verbose = 1 ;
%      p.allowCaching = 0 ;

      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;

      % 'V_1'
      % 'V_2'
      % 'V_3'
      % 'i_{V1_{1,2}}'

      p.nPlus = [ 2 3 ] ;
      p.nMinus = [ 1 0 ] ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      p.figNum = 3 ;
      p.figDesc = 'SourceCurrent' ;
      p.title = 'Source Current' ;
      p.nPlus = 4 ;
      p.nMinus = 0 ;
      p.legends = {} ;
      p.yLabel = 'Current (A)' ;
      PlotWaveforms( p ) ;

      if ( 1 )
         p.figDesc = 'DiodeVoltages' ;
         p.title = 'Diode Voltages' ;
         p.figNum = 4 ;
         p.nPlus = [ 2 0 1 0 ] ;
         p.nMinus = [ 3 1 3 2 ] ;
         p.legends = { 'vd1', 'vd2', 'vd3', 'vd4' } ;
         p.yLabel = 'Voltage (V)' ;
         PlotWaveforms( p ) ;
      else
         p.figNum = 5 ;
         p.nPlus = 2 ;
         p.nMinus = 3 ;
         p.legends = { 'vd1' } ;
         p.yLabel = 'Voltage (V)' ;
         PlotWaveforms( p ) ;

         p.figNum = 6 ;
         p.nPlus = 0 ;
         p.nMinus = 1 ;
         p.legends = { 'vd2' } ;
         p.yLabel = 'Voltage (V)' ;
         PlotWaveforms( p ) ;

         p.figNum = 6 ;
         p.nPlus = 1 ;
         p.nMinus = 3 ;
         p.legends = { 'vd3' } ;
         p.yLabel = 'Voltage (V)' ;
         PlotWaveforms( p ) ;

         p.figNum = 7 ;
         p.nPlus = 0 ;
         p.nMinus = 2 ;
         p.legends = { 'vd4' } ;
         p.yLabel = 'Voltage (V)' ;
         PlotWaveforms( p ) ;
      end

      %p.N = 100 ;
      %p.figNum = 5 ;
      %PlotWaveforms( p ) ;

      %p.N = 50 ;
      p.figNum = 6 ;
      p.dlambda = 0.001 ;
      p.iterations = 20000 ;
      p.minStep = 1e-14 ;
      p.dispfrequency = 10 ;
      p.JcondTol = 1e-12 ;
      %PlotWaveforms( p ) ;
   end

   if ( doAll || 0 )
      p = struct( 'fileName', '../circuits/simpleSingleNodeRectifier.netlist' ) ;
      p.figName = 'simpleRectifierCircuit' ;
      %p.useBigF = 1 ;
      p.figNum = 3 ;
      p.logPlot = 1 ;
      p.figDesc = 'ErrorAndCpuTimes' ;
      p.title = 'Error and CPU times' ;
      p.legends = { 'Normalized Error', 'CPU Time' } ;
      p.xLabel = 'N (Number of Harmonics)' ;
      PlotWaveforms( p ) ;

      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      p.figDesc = 'Voltage' ;
      p.title = 'Voltage' ;
      p.logPlot = 0 ;
      p.legends = { } ;
      p.figNum = 2 ;
      p.nPlus = 1 ;
      p.nMinus = 0 ;
      PlotWaveforms( p ) ;
   end

   if ( doAll3 || 0 )
      p = struct( 'fileName', '../circuits/halfWaveRectifier.netlist' ) ;
      p.figName = 'halfWaveRectifier' ;
      p.figNum = 2 ;
      %p.N = 1 ;

      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      p.figDesc = 'Voltage' ;
      p.title = 'Voltage' ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      %p.verbose = 1 ;
      %p.allowCaching = 0 ;
      PlotWaveforms( p ) ;

      p.figNum = 3 ;
      p.yLabel = 'Voltage (V)' ;
      p.figDesc = 'DiodeCurrent' ;
      p.title   = 'Diode Current' ;
      p.legends = {} ;
      p.nPlus = [ 3 ] ;
      p.nMinus = [ 0 ] ;
      p.yLabel = 'Current (A)' ;
      %p.verbose = 1 ;
      %PlotWaveforms( p ) ;
   end

   if ( doAll2 || 0 )
      p = struct( 'fileName', '../circuits/halfWaveRectifierPow.netlist' ) ;
      p.figName = 'halfWaveRectifierPow' ;
      p.figNum = 2 ;

      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      p.figDesc = 'Voltage' ;
      p.title = 'Voltage' ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      p.iterations = 200 ;
      %p.verbose = 1 ;
      %p.allowCaching = 0 ; % experimenting with taylor expansion of exponential.  doesn't work well.
      PlotWaveforms( p ) ;
   end

   if ( doAll3 || 0 )
      % inputs:
      %V1 1 0 AC 10 1e6
      %D1 1 2 10e-12 25e-3
      %R1 2 0 1000
      %C1 2 0 1e-6

      % outputs:
      %    'V_1'
      %    'V_2'
      %    'i1_0,1'
      p = struct( 'fileName', '../circuits/simpleVrect.netlist' ) ;
      p.figName = 'typicalRectifierCircuit' ;
      p.figNum = 3 ;
      p.logPlot = 1 ;
      p.figDesc = 'ErrorAndCpuTimes' ;
      p.title   = 'Error and CPU times' ;
      p.legends = { 'Normalized Error', 'CPU Time' } ;
      p.xLabel = 'N (Number of Harmonics)' ;
      PlotWaveforms( p ) ;

      p.xLabel = 'Time (s)' ;
      p.logPlot = 0 ;
      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      %p.allowCaching = 0 ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      %p.figNum = 5 ;
      %p.figDesc = 'DiodeCurrent' ;
      %p.title   = 'Diode Current' ;
      %p.nPlus = [ 3 ] ;
      %p.nMinus = [ 0 ] ;
      %p.legends = {} ;
      %p.yLabel = 'Current (A)' ;
      %PlotWaveforms( p ) ;
   end

   if ( doAll3 || 0 )
      p = struct( 'fileName', '../circuits/simpleVrectSmallerCap.netlist' ) ;
      p.figName = 'typicalRectifierCircuitSmallerCap' ;

      p.xLabel = 'Time (s)' ;
      p.logPlot = 0 ;
      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      %p.allowCaching = 0 ;
      p.legends = { 'Source Voltage', 'Output Voltage' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      p.figNum = 3 ;
      p.figDesc = 'DiodeCurrent' ;
      p.title   = 'Diode Current' ;
      p.nPlus = [ 3 ] ;
      p.nMinus = [ 0 ] ;
      p.legends = {} ;
      p.yLabel = 'Current (A)' ;
      PlotWaveforms( p ) ;
   end

   if ( doAll3 || 0 )
      f = figure ;
      hold on ;

      p = struct( 'fileName', '../circuits/halfWaveRectifier.netlist' ) ;
      p.figName = 'halfWaveRectifier' ;
      p.nofigure = 1 ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      PlotWaveforms( p ) ;

      p = struct( 'fileName', '../circuits/simpleVrectSmallerCap.netlist' ) ;
      p.figName = 'typicalRectifierCircuitSmallerCap' ;
      p.nofigure = 1 ;
      p.nPlus = 2 ;
      p.nMinus = 0 ;
      PlotWaveforms( p ) ;

      p = struct( 'fileName', '../circuits/simpleVrect.netlist' ) ;
      p.figName = 'typicalRectifier' ;
      p.nofigure = 1 ;
      p.nPlus = [ 2 ] ;
      p.nMinus = [ 0 ] ;
      p.legends = { 'Source Voltage', 'C = 0', 'C = 1nF', 'C = 1000nF' } ;
      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      set( f, 'Color', 'w' ) ;

      saveName = sprintf( 'halfWaveRectifierRangeOfCapValues.%s', fileExtension ) ;

      savePlot( f, saveName ) ;

      hold off ;
   end

   if ( doAll3 || 0 )
      f = figure ;
      hold on ;

      % C = 0
      p = struct( 'fileName', '../circuits/halfWaveRectifierMultiSource.netlist' ) ;
      p.figName = 'halfWaveRectifierMultiSource' ;
      p.nofigure = 1 ;
      p.nPlus = [ 1 2 ] ;
      p.nMinus = [ 0 0 ] ;
      PlotWaveforms( p ) ;

      % C = 1nF (1e-9)
      p = struct( 'fileName', '../circuits/simpleVrectSmallerCapMultiSource.netlist' ) ;
      p.figName = 'typicalRectifierCircuitSmallerCapMultiSource' ;
      p.nofigure = 1 ;
      p.nPlus = 2 ;
      p.nMinus = 0 ;
      PlotWaveforms( p ) ;

      % C = 1e-9
      p = struct( 'fileName', '../circuits/simpleVrectMediumCapMultiSource.netlist' ) ;
      p.figName = 'typicalRectifierCircuitMediumCapMultiSource' ;
      p.nofigure = 1 ;
      p.nPlus = 2 ;
      p.nMinus = 0 ;
      PlotWaveforms( p ) ;

      % C = 1e-6
      p = struct( 'fileName', '../circuits/simpleVrectMultiSource.netlist' ) ;
      p.figName = 'typicalRectifierMultiSource' ;
      p.nofigure = 1 ;
      p.nPlus = [ 2 ] ;
      p.nMinus = [ 0 ] ;
      p.legends = { 'Source Voltage', 'C = 0', 'C = 1nF', 'C = 10nF', 'C = 1000nF' } ;
      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;

      set( f, 'Color', 'w' ) ;

      saveName = sprintf( 'halfWaveRectifierRangeOfCapValuesMultiSource.%s', fileExtension ) ;

      savePlot( f, saveName ) ;

      hold off ;
   end

   if ( doAll2 || 0 )
      p = struct( 'fileName', '../circuits/LCLowpass.netlist' ) ;
      p.figName = 'lowPassFilter' ;
%      p.useBigF = 0 ;
%      p.verbose = 1 ;

      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      p.figNum = 2 ;
      p.figDesc = 'SourceAndOutputVoltages' ;
      p.title = 'Source and Output Voltages' ;

      % We tried plotting after R2, to see if the voltage drop in the output
      % could be eliminated in comparison to the input source.  However,
      % R2 is really part of the low pass circuit, and plotting there
      % changes the input spectrum.
      % 
      % There may are likely better filters than this one (both with respect
      % to the gross attenuation of the output signal, and with respect to 
      % how much of the higher frequency signals get through the circuit).
      %
      if ( 1 )
         p.nPlus = [ 1 5 ] ;
         p.nMinus = [ 0 0 ] ;
         p.legends = { 'Source Voltage', 'Output Voltage' } ;
      else
         p.nPlus = [ 1 2 5 ] ;
         p.nMinus = [ 0 0 0 ] ;
         p.legends = { 'Source Voltage', 's r2', 'Output Voltage' } ;
      end
      PlotWaveforms( p ) ;

      p.spectrum = 1 ;
      p.xLabel = 'Frequency (MHz)' ;
      p.yLabel = 'Absolute Magnitude' ;
      p.figNum = 3 ;
      p.figDesc = 'InputVoltageSpectrum' ;
      p.title = 'Input Voltage Spectrum' ;
      p.nPlus = 1 ;
      p.nMinus = 0 ;
      p.legends = {} ;
      %p.verbose = 1 ;
      PlotWaveforms( p ) ;

      p.figDesc = 'OutputVoltageSpectrum' ;
      p.title = 'Output Voltage Spectrum' ;
      p.figNum = 4 ;
      p.nPlus = 5 ;
      PlotWaveforms( p ) ;
   end

   if ( doAll || 0 )
      p = struct( 'fileName', '../circuits/square.netlist' ) ;
      p.figName = 'PowerLawAmplifiers' ;

      p.useBigF = 0 ; % BigF Jacobian not implemented for this circuit.
      %p.allowCaching = 0 ;
      p.figNum = 1 ;
      p.figDesc = 'Voltage' ;
      p.title   = 'Voltage' ;
      p.nPlus = [ 1 3 4 ] ;
      p.nMinus = [ 0 0 0 ] ;
      p.legends = { 'v_s', 'v_s^2', 'v_s^3' } ;
      p.xLabel = 'Time (s)' ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;
   end

   % basic visual test of source voltage addition.
   if ( 0 )
      p = struct( 'fileName', '../circuits/x.netlist' ) ;
      p.figName = 'x' ;
      p.xLabel = 'Time (s)' ;

%      p.N = 2 ;
%      p.allowCaching = 0 ;
      p.figNum = 2 ;
      p.figDesc = 'SourceVoltages' ;
      p.title = 'Source voltages' ;
      p.verbose = 1 ;

      p.nPlus = [ 1 3 1  ] ;
      p.nMinus = [ 0 0 3  ] ;
      p.legends = { 'Source Voltage', 's0', 's1' } ;
      p.yLabel = 'Voltage (V)' ;
      PlotWaveforms( p ) ;
   end
end
