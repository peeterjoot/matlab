%
% Assumptions
%
% 1) The input matrix is square (checked) and in upper triangular form (assumed)
% 2) The matrix is invertable (assumed)
% 3) The input vector is size compatable with the matrix (checked)
%

function [ x ] = backsubst( U, b )
% backsubst performs a back substitution returning x for the system U x = b, where U is upper triangular and has no
% zeros on the diagonal.
% 

enableTrace( ) ;
[m, n] = size( U ) ;
bSize = size( b ) ;
x = zeros( m, 1 ) ;

if ( size(U, 2) ~= m )
   error( 'backsubst:squareCheck', 'matrix dimensions %d,%d are not square', m, n ) ;
end

if ( bSize ~= m )
   error( 'backsubst:compatCheck', 'matrix dimensions %d,%d are not compatable with vector dimentions %d', m, n, bSize ) ;
end

% iterate backwards solving for x_m, x_{m-1}, ... in turn.
for i = m:-1:1
   dotprod = 0 ;
   if ( i ~= m )
      dotprod = x(i+1:m) * U(i, i+1:m) ;
   end
   x( i ) = (b(i) - dotprod)/U(i,i) ;
   trace( sprintf('%d; dotprod=%g, b_i=%g, U_ii=%g => x_i = %g', i, dotprod, b(i), U(i,i), x(i) ) ) ;
end
