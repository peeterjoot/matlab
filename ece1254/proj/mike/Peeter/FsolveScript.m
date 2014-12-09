clear
clc

%import data from circuit file
[G, C, B, bdiode, angularVelocities, xnames] = NodalAnalysis('BridgeRectifier.txt');

% Harmonic Balance Parameters
N = 5;
%Only intend on using one frequeny for all AC sources
omega = angularVelocities(end);
f0 = omega/(2*pi);
T = 1/f0;
dt = T/(2*N+1);
t = dt*(-N:N);
k = -N:N;


[Y, Vnames, I, bdiode] = HarmonicBalance(G, C, B, bdiode, angularVelocities, xnames, N, omega);

M = length(G);

% Fourier Transform Matrices
F = FourierMatrix(N,M);
F1 = FourierMatrix(N,1);


% %Newton's Method Parameters
X0 = zeros(M*(2*N+1),1);

%Ensure Problem can be solved with FSOLVE, FSOLVE can only use one variable
%so use an anonymous function to fill in constant parameters
I = @(X) fsolveTest( X, Y, I, N, M, bdiode  );

options = optimoptions('fsolve', 'Display','iter','Jacobian','off','DerivativeCheck', 'off');
% 
[X,fval,exitflag,output,jacobian] = fsolve(I,X0,options);


x = F*X;

%Plot Voltages
v1 = x(1:M:end);
v2 = x(2:M:end);
v3 = x(3:M:end);
i = x(4:M:end);
vr = v3;
close all
figure
subplot(211)
plot(t,v2-v1,t,v2-v3,t,vr)
legend('vs','vd1','vr')
subplot(212)
plot(t,i)
legend('source current')
vd1 = v2-v3;
vd2 = -v1;
vd3 = v1-v3;
vd4 = -v2;
figure
plot(t,vd1,t,vd2,t,vd3,t,vd4)
legend('vd1','vd2','vd3','vd4')

