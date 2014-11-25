function v = vclock( setOfTimesInNanoseconds )
% return vector of clk() values for the specified times.
%

v = zeros( size( setOfTimesInNanoseconds ) ) ;

i = 0 ;
for t = setOfTimesInNanoseconds
   i = i + 1 ;

   v( i ) = clk( t ) ;
end
