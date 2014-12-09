clear
clc

%system parameters
fo = 10;
T = 1/fo;
w = 2*pi*fo;

%Harmonic Balance Paramters
N = 3;
R = zeros(2*N+1,2*N+1);

%time step and time vecotr
deltat = T/(2*N+1);
t = deltat*(-N:N)';
k = -N:N;

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

%Generate F matrix
F = zeros(N,N);
for l = 1:(2*N+1)
    for m = 1:(2*N+1)
        tk = deltat*k(m);
        F(l,m) = exp(-1i*k(l)*tk*w);
    end
end

M =3;
v = zeros(M*2*N+1,1);

for i = 0:2*N
    t = i*deltat;
for k = 1:3
    v((i*3)+k) = k*cos(w*t);
end
end

r = FourierMatrix(N,M);