clear
clc

%system parameters
fo = 10 ;
T = 1/fo ;
w = 2*pi*fo ;

%Harmonic Balance Paramters
N = 3 ;

%circuit nodes
M =3 ;
%vector to hold time domain voltages for M nodes
v = zeros(M*2*N+1,1) ;


%time step and time vecotr
deltat = T/(2*N+1) ;
t = deltat*(-N:N)' ;
k = -N:N ;

%Get Fourier Matrix
R = FourierMatrix(N,M) ;
R1 = FourierMatrix(N,1) ;

for i = 0:2*N
    t = i*deltat ;
    for k = 1:3
        v((i*3)+k) = k*cos(w*t) ;
    end
end

V = R\v ;

n = 3 ;
v1 = v(1:3:end) ;
v2 = v(2:3:end) ;
v3 = v(3:3:end) ;


V1 = R1\v1 ;
V2 = R1\v2 ;
V3 = R1\v3 ;
