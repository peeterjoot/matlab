%PlotWaveforms.m - This script calls the HBSolve function to solve the
%circuit described in fileName using the Harmonic Balance method,
%truncating the harmonics to N multiples of fundamental. 
% Various Parameters of interest of plotted

clear
clc
fileName = 'BridgeRectifier.netlist';

% Harmonic Balance Parameters
N = 50;
[x, X, ecputime, omega, R ] = HBSolve( N, fileName );

f0 = omega/(2*pi);
T = 1/f0;
dt = T/(2*N+1);
k = -N:N;
t = dt*k;

% %Plot Voltages
v1 = real(x(1:R:end));
v2 = real(x(2:R:end));
v3 = real(x(3:R:end));
% v4 = real(x(4:M:end));
% v5 = real(x(5:M:end));
% 
i = real(x(4:R:end));
vr = v3;
close all

figure
plot(t,v2-v1,t,vr)
legend('Source Voltage','Output Voltage')
xlabel('Time (s)')
ylabel('Voltage (V))')
% 
figure
plot(t,i)
title('Source Current')
vd1 = v2-v3;
vd2 = -v1;
vd3 = v1-v3;
vd4 = -v2;
figure
plot(t,vd1,t,vd2,t,vd3,t,vd4)
title('Diode Voltages')
legend('vd1','vd2','vd3','vd4')
xlabel('Time (s)')
ylabel('Voltage (V))')