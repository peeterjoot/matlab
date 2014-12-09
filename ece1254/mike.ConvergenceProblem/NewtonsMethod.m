clear
clc

%import data from circuit file
[G, C, B, bdiode, angularVelocities, xnames] = NodalAnalysis('simple.netlist');

% Harmonic Balance Parameters
N = 3;
%Only intend on using one frequeny for all AC sources
omega = angularVelocities(end);
f0 = omega/(2*pi);
T = 1/f0;
dt = T/(2*N+1);
t = dt*(-N:N);
k = -N:N;


[Y, Vnames, Is, bdiode] = HarmonicBalance(G, C, B, bdiode, angularVelocities, xnames, N, omega);

M = length(G);

% Fourier Transform Matrices
F = FourierMatrix(N,M);
F1 = FourierMatrix(N,1);


%Newton's Method Parameters
X0 = zeros(M*(2*N+1),1);

%tolarances
eI = 1e-6;
edV = 1e-3;

%iteration limits
iterations = 100;
subiterations = 10;
totalIterations = 0;

%Source Stepping
lambda = 0;
plambda = 0;
dlambda = 0.01;

for i = 1:iterations
    X = X0;
    x = F*X;
    
    %determine non linear currents and their derivatives
    
    inl = gnl(bdiode, x, N , M);
    Inl = F\inl;
    
    %Function to minimize I
    I = Y*X + Inl - lambda*Is;
    
    %Construct Jacobian
    Gp = Gprime( bdiode, x, N , M );
    J = Y + Gp;
    disp(['starting iteration ' num2str(i) ' lambda is ' num2str(lambda)]);
    
    for k= 1:subiterations
        %Newton Iteration Update
        dX = J\-I;
        X = X + dX;
        
        %determine non linear currents
        inl = gnl(bdiode, x, N , M);
        Inl = F\inl;
        
        %Function to minimize I
        I = Y*X + Inl - lambda*Is;
        
        %Construct Jacobian
        Gp = Gprime( bdiode, x, N , M );
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

