clear
clc

%system parameters
fo = 2000;
T = 1/fo;
w = 2*pi*fo;

%Harmonic Balance Paramters
N = 10;
R = zeros(2*N+1,2*N+1);

%time step and time vecotr
deltat = T/(2*N+1);
t = deltat*(0:2*N)';

%Generate R matrix
for n=0:2*N
    for m = 0:N
        if m == 0
            R(n+1,m+1) = 1;
        else
            R(n+1,2*m) = cos(m*2*pi*n/(2*N+1));
            R(n+1,2*m+1) = -sin(m*2*pi*n/(2*N+1));
        end
    end
end

V0 = zeros(2*N+1,1);
%options = optimoptions('fsolve','Jacobian','on');
V = fsolve(@fun,V0);
v = R*V;

plot(t,v)

