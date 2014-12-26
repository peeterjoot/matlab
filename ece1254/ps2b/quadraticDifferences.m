function [L, m] = quadraticDifferences(x, xk, filedesc)
% input: x = x^*
% xk: x^[1:iter]
%
if ( nargin < 3 )
   filedesc = 'FigXX' ;
end

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

f = figure ;
%disp(p) ;
plot( u(1:end-1), y, 'r.-' ) ;
xlabel( 'ln |x^{k} - x^*|' ) ;
ylabel( 'ln |x^{k+1} - x^*|' ) ;

[fileExtension, savePlot] = saveHelper() ;

savePlot( f, sprintf( '%s.%s', filedesc, fileExtension ) ) ;
