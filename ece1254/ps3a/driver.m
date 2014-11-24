function [G, C, b, xnames, s] = driver()

filename = 'a.netlist' ;

%[r, endpoints] = generateNetlist( filename, [0.05 ; 0.05] ) ;
[r, endpoints] = generateNetlist( filename ) ;

[G, C, b, xnames] = NodalAnalysis( filename ) ;

%deltaT = 0.5 ;
%deltaT = 0.1 ;
deltaT = 0.01 ;
%deltaT = 0.005 ;
%deltaT = 0.001 ;

%discreteTimes = [0:deltaT:0.25] ;
discreteTimes = [0:deltaT:5] ;

v = vclock(0) ;
bv = b * v ;

s = [] ;

CoverDeltaT = C/ deltaT ;
A = G + CoverDeltaT ;
x = zeros( size(b) ) ;
s(:,end+1) = x ;

% prep for solving A\r
[ L, U, P ] = lu( A ) ;

for t = discreteTimes(2:end)
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

%disp( endpoints(1) ) ;
%disp( size(discreteTimes) ) ;
%disp( size(s) ) ;
%disp( s( 5, : ) ) ;
plot( discreteTimes, s( endpoints(1), : ).' ) ;
