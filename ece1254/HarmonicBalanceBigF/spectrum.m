% LCLowpass.netlist circuit to plot the frequency response. I added it to my copy of PlotWaveforms.m

%Plot Frequency Response
fMHz = k*f0/1e6;
 
f = figure ;  
Vin = X(1:R:end);
stem(fMHz,abs(Vin));
   if ( withTitle )
      title( 'Input Voltage Spectrum' ) ;
   end
xlabel( 'Frequency (MHz)' ) ;
ylabel( 'Absolute Magnitude' ) ;
f = figure ;
Vout = X(5:R:end);
stem(fMHz,abs(Vout));
   if ( withTitle )
      title( 'Output Voltage Spectrum' ) ;
   end
xlabel( 'Frequency (MHz)' ) ;
ylabel( 'Absolute Magnitude' ) ;
