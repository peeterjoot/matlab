 clear
 clc
 
% Circuit parameters
fo = 1;
T = 1/fo;
w = 2*pi*fo;
R = 100;
Vs = 1.5;

% Number of Nodes
Nn = 2;
% Number of MNA elements
Nm = 1;
% Total Unknowns
N = Nn + Nm;

% Harmonic Balance
Nh = 3;
dt = T/(2*Nh+1);
t = dt*(0:2*Nh);

% Fourier Transform Matrices
F = FourierMatrix(Nh,N);
F1 = FourierMatrix(Nh,1);

%Source Vector in Frequency Domain
B = zeros(N*(2*Nh+1),1);
%Source is 0 phase, magnitude Vs
B(N+3)=Vs;

%Need to initialize the nonlinear current vector Inl, will only overwrite
%the values that correspond to the diode current
Inl = zeros(N*(2*Nh+1),1);

%G matrix for series resistor and 1 MNA unknown current from source
Ycell = [1/R -1/R -1; 
        -1/R 1/R 0 ; 
        1 0 0];

%Generate Block Diagonal Y matrix for Nh harmonics
Y = zeros(N*(2*Nh+1),N*(2*Nh+1));
for n = 0:2*Nh
    Y(n*N+1:n*N+N,n*N+1:n*N+N) = Ycell;
end

%Newton's Method Parameters
X0 = zeros(N*(2*Nh+1),1);

%tolarances
eI = 1e-6;
edV = 1e-3;

%iteration limits
iterations = 5000;
subiterations = 10000;
totalIterations = 0;

%Source Stepping
lambda = 0;
plambda = 0;
dlambda = 0.01;

for i = 1:iterations
    X = X0;
    x = F*X;
    
    %Extract Diode voltages in time domain
    vd1 = x(2:N:end);
    %determine non linear currents and their derivatives
    id = Diode(vd1,0);
    Id = F1\id;
    did = dDiode1(vd1,0);
    dId = F1\did;
    
    Inl(2:N:end) = Id;
    %Function to minimize I
    I = Y*X + Inl - lambda*B;
    
    %Construct Jacobian
    J = Y;
    J(2:N:end,2:N:end) = J(2:N:end,2:N:end) + diag(dId);
    
    disp(['starting iteration ' num2str(i) ' lambda is ' num2str(lambda)]);
    
    for k= 1:subiterations
        %Newton Iteration Update
        dX = J\-I;
        X = X + dX;
        
        %Extract Diode voltages in time domain
        vd1 = x(2:N:end);
        %determine non linear currents and their derivatives
        id = Diode(vd1,0);
        Id = F1\id;
        did = dDiode1(vd1,0);
        dId = F1\did;

        Inl(2:N:end) = Id;
        %Function to minimize I
        I = Y*X + Inl - lambda*B;

        %Construct Jacobian
        J = Y;
        J(2:N:end,2:N:end) = J(2:N:end,2:N:end) + diag(dId);

        if (norm(I) < eI) || (norm(dX) < edV) %&& (norm(dV)/norm(V) < edVr)
            k  = k-1;
            break;
        end
    end
    
    if (k >=subiterations) %solution did not converge
        disp('solution did not converge')
        dlambda = dlambda/2;
        lambda = plambda + dlambda;
    else      
        disp('solution converged')
        X0 = X;
        dlambda = 2*dlambda;
        plambda = lambda;
        lambda = lambda + dlambda;
        k = k+1;
    end
    
    totalIterations = totalIterations + k;

    if plambda == 1; break ; end;
    if lambda >=1; lambda = 1; end;
    
    if dlambda<=0.0001
        error('source load step too small, function not converging')
    end
end

%Plot Voltages
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

