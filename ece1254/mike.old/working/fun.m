function [ I, J ] = fun( V  )

%system parameters
fo = 2000;
T = 1/fo;
w = 2*pi*fo;

%Circuit Parameters
Re = 1000;
Imax = 0.001;


%Harmonic Balance Paramters
N = 10;
R = zeros(2*N+1,2*N+1);

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

v = R*V;

%constant vectors
Y = (1/Re)*diag(ones(2*N+1,1));
Is = Imax*[0 ; 1 ; zeros(2*N-1,1)];

Il = Y*V;

inl = Diode(v,0);
Inl = (R\inl);

dinl = diag(dDiode1(v,0));
dInl = -(R\dinl);

I = Il + Inl + Is;
J = Y + dInl;

end

