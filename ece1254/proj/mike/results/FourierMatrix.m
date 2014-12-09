function [ F, R ] = FourierMatrix( N, M )
%FOURIERMATRIX Function to determine the fourier matrix for the discrete
%fourier transform and its inverse.
%N is the number of Harmonics to be used
%M is the number of MNA unknowns i.e. number of nodes in the circuit
%plus the number of additional equations generated from the MNA.


R = zeros(M*(2*N+1),M*(2*N+1));

for n = 0:2*N;
    for l = 0:M-1
        for m = 0:N
            if m == 0
                column = l+1;
                row = n*M + l+1;
                R(row,column) = 1;
            else
                columnR = l+1 + (2*m-1)*M;
                columnI = columnR + M;
                row = n*M + l + 1;
                R(row,columnR) = cos(m*2*pi*n/(2*N+1));
                R(row,columnI) = -sin(m*2*pi*n/(2*N+1));
            end
        end
    end
end

F = zeros(M*(2*N+1),M*(2*N+1));
k = -N:N;
j = -N:N;
for n = 0:2*N;
    for l = 0:M-1
        for m = 0:2*N
            column = l+1 + (m)*M;
            row = n*M + l + 1;
            F(row,column) = exp(1i*2*pi*k(n+1)*j(m+1)/(2*N+1));
        end
    end
end

end

