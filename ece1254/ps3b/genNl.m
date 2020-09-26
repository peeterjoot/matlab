function generateNetlist(filename, n, alpha, useBigResistor)
%
% generate the netlist for the circuit equivalent to the ps3b heat equation.
%
% filename [string]: path to store the netlist in.
% n        [integer]: how many discretization intervals.
% alpha    [float]: heating coefficient.
% useBigResistor [boolean]: instead of using a zero voltage source to force the zero current boundary
%                           value constraint, use a big (i.e. infinite) resistor to model no flow and the
%                           end point.

deltaX = 1/n ;
deltaXsq = deltaX^2 ;
capValue = deltaXsq ;
currentSource = deltaXsq ;
rg = 1/(deltaXsq * alpha) ;

fh = fopen( filename, 'w+' ) ;
if ( -1 == fh )
   error( 'generateNetlist:fopen', 'error opening file "%s"', filename ) ;
end

for i = [1:n+1]
   fprintf( fh, 'R%d %d 0 %e\n', i, i, rg ) ;
   fprintf( fh, 'C%d %d 0 %e\n', i, i, capValue ) ;
   fprintf( fh, 'I%d %d 0 DC %e\n', i, i, -deltaXsq ) ;
end

infinityApproximation = 1e8 ;
rn = n + 2 ;
if ( useBigResistor )
   range = [1:n] ;
else
   range = [2:n-1] ;
end
for i = range
   fprintf( fh, 'R%d %d %d %e\n', rn, i, i + 1, deltaX ) ;

   rn = rn + 1 ;
end

if ( useBigResistor )
   fprintf( fh, 'R%d %d %d %e\n', rn, 1, n + 2, infinityApproximation ) ;
   fprintf( fh, 'C%d %d %d %e\n', rn, 1, n + 2, 1/infinityApproximation ) ;
   fprintf( fh, 'R%d %d %d %e\n', rn + 1, n + 1, n + 3, infinityApproximation ) ;
   fprintf( fh, 'C%d %d %d %e\n', rn + 1, n + 1, n + 3, 1/infinityApproximation ) ;
else
   fprintf( fh, 'V1 1 2 DC 0\n' ) ;
   fprintf( fh, 'V2 %d %d DC 0\n', n, n+1 ) ;
end

fclose( fh ) ;
