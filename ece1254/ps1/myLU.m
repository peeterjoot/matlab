%
% Assumptions
%
% 1) The input matrix is square.
% 2) The matrix is invertable.
%

function [ P, L, U, permutationSign ] = myLU( M )
% myLU performs LU factorization (not in place) of the input matrix, producing the factors: P M = L U,
% where P is a permutation matrix, and L and U are lower and upper triangular respectively.
% 
% Side effects: the determinant of M can be computed by the products of the resulting
% diagonal times the (returned) permutationSign.
%

%enableTrace( ) ;
sz = size(M, 1) ;

if ( size(M, 2) ~= sz )
   error( 'myLU:squareCheck', 'matrix dimensions %d,%d are not square', sz, size(M,2) ) ;
end

% permutation matrix
P = eye( sz ) ;
L = eye( sz ) ;
U = M ;
permutationSign = 1 ; % could use to compute the determinant (product of diagonal of U with this)

for i = 1:sz-1
%disp( M ) ;
   rowContainingMaxElement = findMaxIndexOfColumnMatrix( U(i:sz, i), i - 1 ) ;
   
   % http://stackoverflow.com/questions/4939738/swapping-rows-and-columns 
   % example:
   % A([3 1],2:4) = A([1 3], 2:4)
   % this exchanges the following submatrices (row subsets)
   % - row 1, with columns ranging from 2:4 
   % - row 3, with columns ranging from 2:4 

   trace( sprintf('i = %d, pivotRow = %d', i, rowContainingMaxElement) ) ;
   if ( rowContainingMaxElement ~= i )
      % apply the operation to both U and the permutation matrix that is tracking the row exchanges.

      U( [ rowContainingMaxElement, i ], i:sz ) = U( [ i, rowContainingMaxElement ], i:sz ) ;
      P( [ rowContainingMaxElement, i ], 1:sz ) = P( [ i, rowContainingMaxElement ], 1:sz ) ;

      permutationSign = -permutationSign ;

      trace( sprintf( 'permutation sign: %d, pivot value: %d', permutationSign, U(i,i) ) ) ;
   end 

   % now do the row operations:
   %
   % r_j -> r_j - M_ji/M_ii r_i (apply to columns i+1:sz)
   %
   % M_ji -> M_ji/M_ii (no sign, since this is the inverse operation)
   %
   for j = i+1:sz
      multiplier = U(j, i)/U(i, i) ;

      trace( sprintf('iteration: %d, row %d, multiplier: %d', i, j, multiplier) ) ;

      U( j, i ) = 0 ;
      U( j, i+1:sz ) = U( j, i+1:sz ) - multiplier * U( i, i+1:sz ) ;
      L( j, i ) = multiplier ;
   end
end

% requires two pivots:
%clear all ; A = [0 0 1 ; 2 0 4 ; 1 1 1 ] ; [P, L, U, s] = myLU( A ) ;

% requires no pivots:
%clear all ; A = [2 0 4 ; 1 1 1 ; 0 0 1 ] ; [P, L, U, s] = myLU( A ) ;

%clear all ; A = [1 1 1 ; 2 3 1 ; 3 2 1 ] ; [P, L, U, s] = myLU( A ) ;

% t/c to trigger size checking error:
%clear all ; A = [2 3 1 ; 3 2 1 ] ; [P, L, U, s] = myLU( A ) ;
