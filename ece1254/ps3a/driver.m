function [G, C, B, xnames, s] = driver()

filename = 'a.netlist' ;

r = generateNetlist( filename ) ;

[G, C, b, xnames] = NodalAnalysis( filename ) ;

deltaT = 0.01 ;

discreteTimes = [0:deltaT:0.25] ;

v = vclock(0) ;
bv = b * v ;

s = zeros( size(b, 1), size(discreteTimes, 2) ) ;

CoverDeltaT = C/ deltaT ;
A = G + CoverDeltaT ;
x = zeros( size(b) ) ;
s(:,end+1) = x ;

% prep for solving A\r
[ L, U, P ] = lu( A ) ;

for t = discreteTimes
   newV = vclock( t ) ;
   if ( newV ~= v )
      v = newV ;
      bv = b * v ;
   end

   r = P * (CoverDeltaT * x + bv) ;
   y = L\r ;
   x = U\y ;
   s(:,end+1) = x ;
end

