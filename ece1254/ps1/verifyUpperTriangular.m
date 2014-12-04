%
% Assumptions
%
% 1) The input matrix is square (checked)
% 2) The input matrix is upper triangular (checked)
%

function verifyUpperTriangular( U, epsilon )
% verifyUpperTriangular produces an error if the matrix U is not upper triangular within precision epsilon.
% 

%enableTrace( ) ;
[m, n] = size( U ) ;

if ( n ~= m )
   error( 'verifyUpperTriangular:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

for i = 2:m
   for j = 1:i-1
      u = abs( U(i, j) ) ;
      if ( u > epsilon )
         error( 'verifyUpperTriangular:elementcheck', '|U(%d,%d)| = %f > %f', m, n, u, epsilon ) ;
      end
   end
end
