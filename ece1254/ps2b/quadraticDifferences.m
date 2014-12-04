function [L, m] = quadraticDifferences(x, xk)
% input: x = x^*
% xk: x^[1:iter]
%

u = [] ;
y = [] ;

w = x ;
i = 1 ;
for v = xk ;
   u(i) = log( norm( v - w ) ) ;

   if ( i > 1 )
      y(i-1) = u(i) ;
   end
   i = i + 1 ;
end

v = u(1:end-1) ;
p = polyfit( v, y, 1 ) ;
m = p(1) ;
L = exp( p(2) ) ;

%disp(p) ;
plot( u(1:end-1), y, 'r.-' ) ;
xlabel( 'ln |x^{k} - x^*|' ) ;
ylabel( 'ln |x^{k+1} - x^*|' ) ;
