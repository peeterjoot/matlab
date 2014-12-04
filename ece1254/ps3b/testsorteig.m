function testsorteig( mode )
% called with 'descend' expect to see the eigenvalue with the most negative real part in the 4,4 position.

   if ( nargin < 1 )
      mode = 'ascend' ;
   end

   a = 10*(rand(4) + i * rand(4)) ;

   [v,d] = sorteig( a, mode ) ;

   d

   max(max(abs(a - v * d * inv(v))))

end
