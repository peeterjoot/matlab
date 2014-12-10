function [ x, X, ecputime, omega, R ] = HBSolve( N, fileName )
%HB Solve - This function uses the Harmonic Balance Method to solve the
%steady state condtion of the circuit described in fileName. Harmonic
%Frequencies are limited to N.
%It returns the vector containing the unknowns of the circuit, x, ordered as
%described in HarmonicBalance.m and the cpu time required to solve the
%circuit using Newton's Method

r = NodalAnalysis( fileName ) ;

% Harmonic Balance Parameters
%Only intend on using one frequency for all AC sources
omega = min(r.angularVelocities(find (r.angularVelocities > 0 ) )) ;

[Y, ~, Is, ~] = HarmonicBalance(r.G, r.C, r.B, r.bdiode, r.angularVelocities, r.xnames, N, omega) ;
R = length(r.G) ;

% Fourier Transform Matrix
F = FourierMatrix(N,R) ;

%Newton's Method Parameters
X0 = zeros(R*(2*N+1),1) ;

%tolarances
eI = 1e-6 ;
edV = 1e-3 ;

%maximum allowed Jacobian Condtion
JcondTol = 1e-23 ;

%iteration limits
iterations = 50 ;
subiterations = 50 ;
totalIterations = 0 ;

%Source Stepping
lambda = 0 ;
plambda = 0 ;
dlambda = 0.01 ;
converged = 0 ;
ecputime = cputime ;
for i = 1:iterations
    X = X0 ;
    x = F*X ;
    
    %determine non linear currents
    inl = gnl(r.bdiode, x, N , R) ;
    Inl = F\inl ;
    
    %Function to minimize I
    I = Y*X + Inl - lambda*Is ;
    
    %Construct Jacobian
    Gp = Gprime( r.bdiode, x, N , R ) ;
    J = Y + Gp ;
    
    disp(['starting iteration ' num2str(i) ' lambda is ' num2str(lambda) ' norm of X0 = ' num2str(norm(X0))]) ;
    stepConverged = 0 ;
    for k= 1:subiterations
        
        %Newton Iteration Update
        dX = J\-I ;
        X = X + dX ;
        x = F*X ;
        
        %determine non linear currents
        inl = gnl(r.bdiode, x, N , R) ;
        Inl = F\inl ;
        
        %Function to minimize I
        I = Y*X + Inl - lambda*Is ;
        
        %Construct Jacobian
        Gp = Gprime( r.bdiode, x, N , R ) ;
        J = Y + Gp ;
        
        if ( (rcond(J) < JcondTol) || ( isnan(rcond(J)) ))
            stepConverged = 0 ;
            break
        end
        
        if (norm(I) < eI) || (norm(dX) < edV) %&& (norm(dV)/norm(V) < edVr)
            stepConverged = 1 ;
            break ;
        end
    end
    
    if ( stepConverged ) %solution did not converge
        %disp('solution converged')
        X0 = X ;
        dlambda = 2*dlambda ;
        plambda = lambda ;
        lambda = lambda + dlambda ;
    else
        %disp('solution did not converge')
        dlambda = dlambda/2 ;
        lambda = plambda + dlambda ;
    end
    
    totalIterations = totalIterations + k ;
    
    if plambda == 1 && stepConverged == 1 ;
        converged = 1 ;
        break ;
    end ;
    if lambda >=1; lambda = 1; end ;
    
    if dlambda<=0.0001
        error('source load step too small, function not converging')
    end
    
end
ecputime = cputime - ecputime ;

if ( converged )
   disp(['solution converged after ' num2str(totalIterations) ' iterations '])
else
   disp(['solution did not converge'])
end



end

