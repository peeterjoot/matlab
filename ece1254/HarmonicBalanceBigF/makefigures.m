function makefigures()

   %clear
   %clc
   close all ;

   p = struct( 'fileName', '../circuits/BridgeRectifier.netlist' ) ;
   p.figName = 'bridgeRectifier' ;
   p.title = '' ;
   p.xLabel = 'Time (s)' ;

if ( 0 )
   %p.title = 'Source Current' ;
   p.figNum = 2 ;
   p.nPlus = [ 2 3 ] ;
   p.nMinus = [ 1 0 ] ;
   p.legends = { 'Source Voltage', 'Output Voltage' } ;
   p.yLabel = 'Voltage (V)' ;
   PlotWaveforms( p ) ;

   %p.title = '' ;
   p.figNum = 3 ;
   p.nPlus = [ 4 ] ;
   p.nMinus = [ 0 ] ;
   p.legends = {} ;
   p.yLabel = 'Current (A)' ;
   PlotWaveforms( p ) ;

   %p.title = 'Diode Voltages' ;
   p.figNum = 4 ;
   p.nPlus = [ 2 0 1 0 ] ;
   p.nMinus = [ 3 1 3 2 ] ;
   p.legends = { 'vd1', 'vd2', 'vd3', 'vd4' } ;
   p.yLabel = 'Voltage (V)' ;
   PlotWaveforms( p ) ;
end

if ( 1 )
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
   p.title = '' ;
   p.xLabel = 'Time (s)' ;

   %p.title = '' ;
   p.figNum = 2 ;
   p.nPlus = [ 1 2 ] ;
   p.nMinus = [ 0 0 ] ;
   p.legends = { 'Source Voltage', 'Output Voltage' } ;
   p.yLabel = 'Voltage (V)' ;
   PlotWaveforms( p ) ;

   %p.title = '' ;
   p.figNum = 5 ;
   p.nPlus = [ 3 ] ;
   p.nMinus = [ 0 ] ;
   p.legends = {} ;
   p.yLabel = 'Current (A)' ;
   PlotWaveforms( p ) ;
end

end
