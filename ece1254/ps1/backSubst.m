%
% Assumptions
%
% 1) The input matrix is square (checked) and in upper triangular form (checked)
% 2) The matrix is invertable (assumed)
% 3) The input vector is size compatable with the matrix (checked)
%

function x = backSubst( U, b, epsilon )
% backSubst performs a back substitution returning x for the system U x = b, where U is upper triangular and has no
% zeros on the diagonal.
%

%enableTrace( ) ;
[m, n] = size( U ) ;
[bm, bn] = size( b ) ;
x = zeros( m, 1 ) ;

if ( n ~= m )
   error( 'backSubst:squareCheck', 'matrix with dimensions %d,%d are not square', m, n ) ;
end

if ( bn ~= 1 )
   error( 'backSubst:columnCheck', 'vector with dimensions %d,%d is not a column vector', bm, bn ) ;
end

if ( bm ~= m )
   error( 'backSubst:compatCheck', 'matrix dimensions %d,%d are not compatable with vector dimensions %d,%d', m, n, bm, bn ) ;
end

if ( isDebugEnabled() )
   verifyUpperTriangular( U, epsilon ) ;
end

% iterate backwards solving for x_m, x_{m-1}, ... in turn.
for i = m:-1:1
   dotprod = 0 ;
   bi = b(i, 1) ;
   uii = U(i, i) ;
   if ( i ~= m )
      % The dot() function takes care of the transpose operation if required (so that the result is a scalar
      % and not a matrix) :
      dotprod = dot( x(i+1:m), U(i, i+1:m) ) ;
   end
   %traceit( sprintf('%d; dotprod=%g, b_i=%g, U_ii=%g\n', i, dotprod, bi, uii ) ) ;

% debug code for 'Subscripted assignment dimension mismatch.' error:
%disp( 'x_i1' ) ;
%disp( x(i, 1) ) ;
%size( x(i, 1) ) ;
%
%disp( 'b_i1' ) ;
%disp( bi ) ;
%size( bi ) ;
%
%disp( 'U_ii' ) ;
%disp( uii ) ;
%disp( size(uii) ) ;
%
%disp( 'dotprod' ) ;
%disp( dotprod ) ;
%disp( size(dotprod) ) ;

   x( i, 1 ) = (bi - dotprod)/uii ;

   %traceit( sprintf('%d; x_i = %g\n', i, x(i, 1) ) ) ;
end
