function [t, v] = checkvclock()
% plot vclock(t) for a couple periods to verify the piecewise logic was replicated properly.

% this dumb seeming test code is because vclock() doesn't auto-vectorize,
% at least as written.
%
% asked how to do that here:
% http://stackoverflow.com/questions/27097861/how-to-vectorize-matlab-function
% 

t = [ 0:0.05:4 ] ;

v = zeros(size(t)) ;

i = 0 ;
for tt = t
   i = i + 1 ;

   v(i) = vclock( tt ) ;
end

plot( t, v ) 
