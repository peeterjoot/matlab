function [ dId ] = dDiode2( V1,V2 )
%DDIODE1 Derivative of Diode function with respect to V1
Is = 10e-12;
Vt = 25e-3;
dId = -(Is/Vt)*exp((V1-V2)/Vt);

end


