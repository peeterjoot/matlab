clear all ;

totalTimes = [ 9.6406e-003     5.0432e-003    17.8881e-003    32.6787e-003    49.6617e-003    82.5970e-003    91.5545e-003   263.9244e-003 345.0983e-003   608.6959e-003     1.0167e+000     1.7369e+000     2.7467e+000 ] ;

gridSizes = [ 2.0000e+000     4.0000e+000     8.0000e+000    10.0000e+000    12.0000e+000    14.0000e+000    16.0000e+000    20.0000e+000 24.0000e+000    28.0000e+000    32.0000e+000    36.0000e+000    40.0000e+000 ] ;

numGrids = size( gridSizes, 2 ) ;

logTotalTimes = log( totalTimes ) ;
logN = log( gridSizes ) ;

p = polyfit( logN, logTotalTimes, 1 ) ;
m = p(1) ;
a = p(2) ;

fitCheck = zeros(numGrids, 1) ;
logFitCheck = zeros(numGrids, 1) ;
for i = 1:numGrids
   logFitCheck(i) = a + logN( i ) * m ;
   fitCheck(i) = exp(a) * gridSizes(i)^m ;
end

figure ; plot( logN, logFitCheck, logN, logTotalTimes )
figure ; plot( gridSizes, fitCheck, gridSizes, totalTimes )

