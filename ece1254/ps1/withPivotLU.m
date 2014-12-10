%
% Assumptions
%
% 1) The input matrix is square.
% 2) The matrix is invertable.
%

function [ P, L, U, permutationSign ] = withPivotLU( U, epsilon )
% withPivotLU performs LU factorization (not in place) of the input matrix, producing the factors: M = L U,
% where L' = P L and U are lower and upper triangular respectively, and P is a permutation matrix.
%
% also returns a +-1 value 's' that can be used to compute the determinant from U (d = s \prod_i U_ii).
% (this is because, except for the permutations, we use only elementary matrix operations that do not alter
%  the determinant).

%enableTrace( ) ;
[m, n] = size( U ) ;

if ( n ~= m )
   error( 'withPivotLU:squareCheck', 'matrix dimensions %d,%d are not square', m, n ) ;
end

% permutation matrix
P = eye( m ) ;
L = eye( m ) ;
permutationSign = 1 ;

% trace disabled now that the correct operation of this function has been verified.
for i = 1:m-1
%disp( sprintf('iter: %d.  U,U_1 = \n', i ) ) ;
%disp( U ) ;
%disp( U(i:m, i) ) ;
   rowContainingMaxElement = findMaxIndexOfColumnMatrix( U(i:m, i), i - 1 ) ;

   % http://stackoverflow.com/questions/4939738/swapping-rows-and-columns
   % example:
   % U([3 1],2:4) = U([1 3], 2:4)
   % this exchanges the following submatrices (row subsets)
   % - row 1, with columns ranging from 2:4
   % - row 3, with columns ranging from 2:4

   %traceit( sprintf('i = %d, pivotRow = %d', i, rowContainingMaxElement) ) ;
   if ( rowContainingMaxElement ~= i )
      % apply the operation to both U and the permutation matrix that is tracking the row exchanges.

      % we are applying the permutation as a row operation to M_{i+1} = P M_i (left multiplication).
      % Apply the same permuation as a column operation (i.e. right multiplication)
      % L_{i+1} = L_i P
      L( 1:m, [ rowContainingMaxElement, i ] ) = L( 1:m, [ i, rowContainingMaxElement ] ) ;
      U( [ rowContainingMaxElement, i ], i:m ) = U( [ i, rowContainingMaxElement ], i:m ) ;

      %%traceit( sprintf('iter: %d.  pivot: %d <-> %d.  U = %s\n', i, rowContainingMaxElement, i, num2str( U ) ) ) ;

      P( [ rowContainingMaxElement, i ], 1:m ) = P( [ i, rowContainingMaxElement ], 1:m ) ;

      permutationSign = -permutationSign ;

      %traceit( sprintf( 'permutation sign: %d, pivot value: %d', permutationSign, U(i,i) ) ) ;
   end

   % now do the row operations:
   %
   % r_j -> r_j - M_ji/M_ii r_i (apply to columns i+1:m)
   %
   % M_ji -> M_ji/M_ii (no sign, since this is the inverse operation)
   %
   for j = i+1:m
      if ( abs(U(j, i)) > epsilon )
         multiplier = U(j, i)/U(i, i) ;

         %traceit( sprintf('iteration: %d, row %d, multiplier: %d', i, j, multiplier) ) ;

         % rows: U_j -> U_j - m U_i
         U( j, i ) = 0 ;
         U( j, i+1:m ) = U( j, i+1:m ) - multiplier * U( i, i+1:m ) ;

         if ( 0 )
            % this is a stupid inefficient way to do this:
            %Ltemp = eye( m ) ;
            %Ltemp( j, i ) = multiplier ;
            %L = L * Ltemp ;
         else
            % what we are really doing is applying a column operation (notice the transposition of indexes and signs
            %  relative to the row operation above applied to U)
            % column: L_i -> L_i + m L_j
            L( :, i) = L( :, i) + multiplier * L( :, j) ;
         end

      else
         %traceit( sprintf('iteration: %d, row %d, multiplier: <= epsilon', i, j) ) ;
      end
   end
end

if ( isDebugEnabled() )
   verifyUpperTriangular( U, epsilon ) ;
   verifyUpperTriangular( (P * L).', epsilon ) ;
end
