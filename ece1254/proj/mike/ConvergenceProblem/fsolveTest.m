function [ I ] = fsolveTest( X, Y, Is, N, M, bdiode  )


% Fourier Transform Matrices
F = FourierMatrix(N,M);

x = F*X;

%determine non linear currents and their derivatives

inl = gnl(bdiode, x, N , M);
Inl = F\inl;

%Function to minimize I
I = Y*X + Inl - Is;

%Construct Jacobian
%Gp = Gprime( bdiode, x, Nh , N );
%J = Y + Gp;
    

