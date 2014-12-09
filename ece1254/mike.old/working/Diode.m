function [ I ] = Diode( V1,V2 )
%DIODE Simple function to determine the current through a diode from its
%voltage

Is = 10e-12;
Vt = 26e-3;

I = Is*(exp((V1-V2)/Vt)-1);


end

