clear
clc

%import data from circuit file
[G, C, B, bdiode, u, xnames] = NodalAnalysis('circuit.txt');

% Circuit parameters
fo = u(2);
T = 1/fo;
w = 2*pi*fo;
Vs = 1.5;

N = length(G);

% Harmonic Balance
Nh = 3;
dt = T/(2*Nh+1);
t = dt*(-Nh:Nh);

% Fourier Transform Matrices
F = FourierMatrix(Nh,N);
F1 = FourierMatrix(Nh,1);

%Source Vector in Frequency Domain
Is = zeros(N*(2*Nh+1),1);

for n = 1:N
    
    Is(N*(Nh - 1) + (n ) ) = 0.5*B(n,2);
    Is(N*(Nh + 1) + (n ) ) = 0.5*conj(B(n,2));
    
end

%Generate Block Diagonal Y matrix for Nh harmonics
Y = zeros(N*(2*Nh+1),N*(2*Nh+1));
for n = 0:2*Nh
    blockStart = n*N+1;
    blockEnd = blockStart+N-1;
    Y( blockStart : blockEnd , blockStart : blockEnd ) = G;
end

%Newton's Method Parameters
X0 = zeros(N*(2*Nh+1),1);

%tolarances
eI = 1e-6;
edV = 1e-3;

%iteration limits
iterations = 100;
subiterations = 1000;
totalIterations = 0;

%Source Stepping
lambda = 0;
plambda = 0;
dlambda = 0.01;

for i = 1:iterations
    X = X0;
    x = F*X;
    
    %determine non linear currents and their derivatives
    
    inl = gnl(bdiode, x, Nh , N);
    Inl = F\inl;
    
    %Function to minimize I
    I = Y*X + Inl - lambda*Is;
    
    %Construct Jacobian
    Gp = Gprime( bdiode, x, Nh , N );
    J = Y + Gp;
    disp(['starting iteration ' num2str(i) ' lambda is ' num2str(lambda)]);
    
    for k= 1:subiterations
        %Newton Iteration Update
        dX = J\-I;
        X = X + dX;
        
        %determine non linear currents
        inl = gnl(bdiode, x, Nh , N);
        Inl = F\inl;
        
        %Function to minimize I
        I = Y*X + Inl - lambda*Is;
        
        %Construct Jacobian
        Gp = Gprime( bdiode, x, Nh , N );
        J = Y + Gp;
        
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

