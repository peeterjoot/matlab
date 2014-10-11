%
% Assumptions
%
% 1) The input matrix is square (checked) and in lower triangular form (checked)
% 2) The matrix is invertable (assumed)
% 3) The input vector is size compatable with the matrix (checked)
%

function x = forwardSubst( L, b, epsilon )
% forwardSubst performs a back substitution returning x for the system L x = b, where L is lower triangular and has no
% zeros on the diagonal.
% 

enableTrace( ) ;
[m, n] = size( L ) ;
[bm, bn] = size( b ) ;
x = zeros( m, 1 ) ;

if ( n ~= m )
   error( 'forwardSubst:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

if ( bn ~= 1 )
   error( 'forwardSubst:columnCheck', 'vector with dimensions %d,%d is not a column vector', bm, bn ) ;
end

if ( bm ~= m )
   error( 'forwardSubst:compatCheck', 'matrix dimensions %d,%d are not compatable with vector dimensions %d,%d', m, n, bm, bn ) ;
end

verifyLowerTriangular( L, epsilon ) ;

% iterate backwards solving for x_m, x_{m-1}, ... in turn.
for i = 1:m
   dotprod = 0 ;
   bi = b(i, 1) ;
   uii = L(i, i) ;
   if ( i ~= 1 )
      % The dot() function takes care of the transpose operation if required (so that the result is a scalar 
      % and not a matrix) :
      dotprod = dot( x(1:i-1), L(i, 1:i-1) ) ;
   end
   trace( sprintf('%d; dotprod=%g, b_i=%g, U_ii=%g\n', i, dotprod, bi, uii ) ) ;

   x( i, 1 ) = (bi - dotprod)/uii ;

   trace( sprintf('%d; x_i = %g\n', i, x(i, 1) ) ) ;
end
