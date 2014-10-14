function ps1d()
% driver that calculates G\b and the corresponding LU factorization based solution for ps3.p1.

[G, b] = NodalAnalysis( 'testdata/ps1.circuit.netlist' ) ;

% For debug: rescale to make less ill conditioned.
% This doesn't make a difference numerically with double precision,
% but is nice for display of the matrix so it doesn't show up as all zeros
if ( 0 )
   G(1:5,:) = 1000 * G(1:5,:) ;
   G(6:8,:) = G(6:8,:)/1000 ;
   b(1:5) = 1000 * b(1:5) ;
   b(6:8) = b(6:8)/1000 ;
end

epsilon = eps( 1.0 ) * 100 ;
%[P, L, U, s] = myLU( G ) ;
%[P, L, U, s] = withPivotLU( G, epsilon ) ;

[L, U] = noPivotLU( G, epsilon ) ;
y = forwardSubst( L, b, epsilon ) ;
x = backSubst( U, y, epsilon ) ;

format short eng ;
G
G\b  % ps1: 1c.
x

% sanity check: expect zero:
G - L * U
