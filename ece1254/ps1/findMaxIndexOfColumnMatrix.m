% Implementation: See that max() can also return the index, but I want the absolute maximum.
% Is there something like the mathematica thread operations that I could use to apply abs() to all the elements of
% this column matrix?
%http://stackoverflow.com/questions/13531009/find-max-and-its-index-in-array-in-matlab

function maxIndex = findMaxIndexOfColumnMatrix( C, offset )
% findMaxIndexOfColumnMatrix finds the index of the pivot element (the biggest absolute value)

[m, n] = size(C) ;
if ( n ~= 1 )
   error( 'findMaxIndexOfColumnMatrix:dimensions', 'expected column vector, not matrix with dimensions (%d,%d)', m, n ) ;
end
maxIndex = 0 ;
maxValue = -1 ;
for r = 1:m
   e = abs( C(r) ) ;

   if ( e > maxValue )
      maxValue = e ;
      maxIndex = r ;
   end
end

maxIndex = maxIndex + offset ;
