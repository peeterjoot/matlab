function [G, C, b, xnames, s] = driver()

filename = 'a.netlist' ;

[r, endpoints] = generateNetlist( filename, [0.05 ; 0.05] ) ;
%[r, endpoints] = generateNetlist( filename ) ;

[G, C, b, xnames] = NodalAnalysis( filename ) ;

%deltaT = 0.5e-9 ;
%deltaT = 0.1e-9 ;
deltaT = 0.01e-9 ;
%deltaT = 0.005e-9 ;
%deltaT = 0.001e-9 ;

%discreteTimes = [0:deltaT:0.25] ;
discreteTimes = [0:deltaT:5e-9] ;

v = vclock(0) ;
bv = b * v ;

s = [] ;

CoverDeltaT = C/ deltaT ;
disp( G ) ;
disp( CoverDeltaT ) ;
disp( b ) ;
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
for e = endpoints
   plot( discreteTimes, s( e, : ).' ) ;
   hold on ;
end
