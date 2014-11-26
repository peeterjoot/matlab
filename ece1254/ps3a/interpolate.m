function w = interpolate( v, inputDeltaT, newDeltaT, maxT )
% Given a set of values v measured at all the points in [0, maxT] separated by timestep inputDeltaT:
% Produce a set of linearly interpolated values for v computed using a different (presumably finer granularity) timestep size newDeltaT
%
% Assumptions:
% - v is a row vector of size maxT/inputDeltaT + 1.
% - inputDeltaT, newDeltaT < maxT are in seconds.
% - inputDeltaT, newDeltaT both divide maxT evenly.

traceit( sprintf('size v = %d:%d\n', size(v, 1), size(v, 2)) ) ;

newN = maxT/newDeltaT + 1 ;
inputN = size( v, 2 ) ;
w = zeros( 1, newN ) ;

i = 1 ;
for t = [0:newDeltaT:maxT]
   k = floor( t / inputDeltaT ) ;
   kFloor = k * inputDeltaT ;
   k = k + 1 ;

   if ( (k + 1) <= inputN )
      w(i) = v(k) + ( v(k+1) - v(k) ) * (t - kFloor)/inputDeltaT ;
   else
      w(i) = v(inputN) ;
   end

   i = i + 1 ;
end
