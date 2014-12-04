function [V,D] = sorteig(A, mode)
% eig() equivalent, but sorted by the (absolute) value of the eigenvalues.
% mode parameter is 'ascend' or 'descend', like sort mode.

   if ( nargin < 2 )
      mode = 'ascend' ;
   end

   [V, D] = eig( A ) ;

   d = diag( D ) ;
   if ( 0 ) 
      [~, p] = sort( abs(d), mode ) ; % ignore the actual sort results.  Just want the index.
      ds = d( p ) ;
   else
      [~, p] = sort( real(d), mode ) ;
      ds = d( p ) ;
   end

   V = V(:, p) ; % p like [ 3 2 1 4 ], so this permutes the columns

   D = diag( ds ) ; % reconstruct the diagonal matrix of (sorted) eigenvalues.
end
