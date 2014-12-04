function x = tridiagonal( a )
% extract just the tridiagonal subset of the matrix a

[m, n] = size( a ) ;

if ( n ~= m )
   error( 'tridiagonal:squareCheck', 'matrix dimensions %d,%d are not square', m, n ) ;
end

d = spdiags(a, -1:1) ;
x = sparse(diag(d(2:n,3), 1) + diag(d(:,2), 0) + diag(d(1:n-1,1), -1)) ;
