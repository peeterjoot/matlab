function generateNetlist(filename, n, alpha)
% filename [in]: path to store the netlist in.
% n        [in]: how many discretization intervals.
% alpha    [in]: heating coefficient.

deltaX = 1/n ;
deltaXsq = deltaX^2 ;
capValue = deltaXsq ;
currentSource = deltaXsq ;
rg = 1/(deltaXsq * alpha) ;

fh = fopen( filename, 'w+' ) ;
if ( -1 == fh )
   error( 'generateNetlist:fopen', 'error opening file "%s"', filename ) ;
end

fprintf( fh, 'V1 1 2 DC 0\n' ) ;
fprintf( fh, 'V2 %d %d DC 0\n', n, n+1 ) ;

for i = [1:n+1]
   fprintf( fh, 'R%d %d 0 %e\n', n, n, rg ) ;
   fprintf( fh, 'C%d %d 0 %e\n', n, n, capValue ) ;
   fprintf( fh, 'I%d %d 0 DC %e\n', n, n, -deltaXsq ) ;
end

rn = n + 2 ;
for i = [2:n-1]
   fprintf( fh, 'R%d %d %d %e\n', rn, i, i + 1, deltaX ) ;

   rn = rn + 1 ;
end

fclose( fh ) ;
