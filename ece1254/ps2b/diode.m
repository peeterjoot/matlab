function f = diode(x, lambda)

f = x - lambda * 5 ;
f = f + 1e-6 * exp( 80 * x ) ;
