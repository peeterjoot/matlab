clear
clc
fo = 1;
T = 1/fo;
w = 2*pi*fo;


% Number of Nodes
Nn = 2;
% Number of MNA elements
Nm = 1;
% Total Unknowns
N = Nn + Nm;

% Harmonic Balance Parameters
Nh = 20;
dt = T/(2*Nh+1);
t = dt*(0:2*Nh);
X0 = zeros(N*(2*Nh+1),1);


options = optimoptions('fsolve','Jacobian','on');
X = fsolve(@vrect,X0);

R = FourierMatrix(Nh,N);

x=R*X;

v1 = x(1:N:end);
v2 = x(2:N:end);
i  = x(3:N:end);
vr = v1-v2;
close all
figure
subplot(211)
plot(t,v1,t,v2,t,vr)
legend('v1','v2','vr')
subplot(212)
plot(t,Diode(v2,0),t,i)
legend('diode current','source current')