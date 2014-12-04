function [t, v] = checkvclock()
% plot vclock(t) for a couple periods to verify the piecewise logic and later vectorization was replicated properly.

t = [ 0:0.05:5 ] * 1e-9 ;

v = vclock( t ) ;

plot( t, v ) ;
