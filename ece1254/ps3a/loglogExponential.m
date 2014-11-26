function loglogExponential()

f = figure ;
t=[10:10:500] ;
plot( t, t.^(-1.05)) ;
hold on ;
plot( t, t.^(-0.6) ) ;
legend( {'m = -1.05', 'm = -0.6'} ) ;
xlabel('N') ;
ylabel('N^m') ;

saveas( f, 'ps3aLogLogExponentialFig7.png' ) ;
