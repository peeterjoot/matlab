function generateHeatNetlist(filename, N, doProblemA, withSineSource )
% A small matlab function that generates a netlist for the heat network in ps1 p3a.
%
% For details see the ps1 pdf.
%
   %enableTrace() ;
   traceit( ['filename: ', filename] ) ;

% ps3.d.
% attempt 1) commit: 44ff3320a9b53aaa2656d9e2b89cdd7b75f4c73a
%
% This used an integral, approximated by a sum to express the constraint.
% This generated a meaningless looking plot (scale was way wrong, values went negative,
% and also didn't have zero heat flow at the origin.)
%
% attempt 2) commit: c9eb48b2b9d53d62a131cf6ab0fd5f9c42dd8685
%
% This used a zero valued current source between nodes 1 and 2, and nodes N-1, N.
% That did not result in stable numerical results, with the orientation of the plot
% flipping as N was varied.  This also didn't have a flat slope at
% the end points, but was zero sloped in the center.

   resistorNumber = 0 ;

   %delete( filename ) ;

   fh = fopen( filename, 'w+' ) ;
   if ( -1 == fh )
      error( 'generateHeatNetlist:fopen', 'error opening file "%s"', filename ) ;
   end

   kappaM = 0.1 ;
   kappaA = 0.001 ;
   deltaX = 1/(N-1) ;
   hAmp = 50 ;
   tZero = 400 ;
   tEnds = 250 ;

   % final node is for the ambiant temperature.
   fprintf( fh, 'V1 %d 0 DC %f\n', N + 1, tZero ) ;

   if ( doProblemA )
      fprintf( fh, 'V2 1 0 DC %f\n', tEnds ) ;
      fprintf( fh, 'V3 %d 0 DC %f\n', N, tEnds ) ;

      firstResistorNodeStart = 1 ;
      lastResistorNodeStart = N-1 ;
   else
      firstResistorNodeStart = 2 ;
      lastResistorNodeStart = N-2 ;

      %fprintf( fh, 'I%d 1 2 DC 0\n', N+1 ) ;
      %fprintf( fh, 'I%d %d %d DC 0\n', N+2, N-1, N ) ;

      fprintf( fh, 'V%d 1 2 DC 0\n', N+1 ) ;
      fprintf( fh, 'V%d %d %d DC 0\n', N+2, N-1, N ) ;
   end

   for i = firstResistorNodeStart:lastResistorNodeStart
      resistorNumber = resistorNumber + 1 ;

      fprintf( fh, 'R%d %d %d %f\n', resistorNumber, i, i + 1, deltaX ) ;
   end

   leakageResistance = kappaM/(kappaA * deltaX) ;
   for i = 1:N
      resistorNumber = resistorNumber + 1 ;

      fprintf( fh, 'R%d %d %d %f\n', resistorNumber, i, N + 1, leakageResistance ) ;
   end

   for i = 1:N
      xi = (i - 1) * deltaX ;
      if ( doProblemA || withSineSource )
         si = sin( 2 * pi * xi ) ;
      else
         si = 1 ;
      end

      traceit( sprintf('i: %d, xi: %f, si: %f, H/\\kappa_m = %f', i, xi, si, hAmp/ kappaM ) ) ;
      current = hAmp * deltaX * si * si / kappaM ;

      fprintf( fh, 'I%d 0 %d DC %f\n', i, i, current ) ;
   end

   fclose( fh ) ;
end
