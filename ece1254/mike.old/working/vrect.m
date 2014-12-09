function [ I , J] = vrect( X )
%Function to use with FSOLVE representing Series half wave rectifier

fo = 1;
T = 1/fo;
w = 2*pi*fo;


R = .1;
Vs = 100;

% Number of Nodes
Nn = 2;
% Number of MNA elements
Nm = 1;
% Total Unknowns
N = Nn + Nm;

% Harmonic Balance
Nh = 20;
dt = T/(2*Nh+1);
t = dt*(0:2*Nh);

% Fourier Transform Matrices
F = FourierMatrix(Nh,N);
F1 = FourierMatrix(Nh,1);

B = zeros(N*(2*Nh+1),1);
B(2*N+3)=Vs;

Ycell = [1/R -1/R -1; -1/R 1/R 0 ; 1 0 0];

Y = zeros(N*(2*Nh+1),N*(2*Nh+1));
    Inl = zeros(N*(2*Nh+1),1);
for n = 0:2*Nh
    Y(n*N+1:n*N+N,n*N+1:n*N+N) = Ycell;
end


    x = F*X;
    
    vd1 = x(2:N:end);
    id = Diode(vd1,0);
    Id = F1\id;
    did = dDiode1(vd1,0);
    dId = F1\did;
    


    
    Inl(2:N:end) = Id;
    I = Y*X + Inl - B;
    J = Y;
    
    J(2:N:end,2:N:end) = J(2:N:end,2:N:end) + diag(dId);


end

