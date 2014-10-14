function generateHeatNetlist(filename, N, doProblemA)
% A small matlab function that generates a netlist for the heat network in ps1 p3a.
%
% For details see the ps1 pdf.
%
   %enableTrace() ;
   trace( ['filename: ', filename] ) ;

   resistorNumber = 0 ;

   delete( filename ) ;

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
   else
      tEnd =  N * 50 / kappaA ;

      fprintf( fh, 'V2 %d %d DC %f\n', 2 * N, N, tEnd ) ;

      j=1
      for i = N+1:N+N-1
         % Elabel node+ node- nodectrl+ nodectrl- gain
         fprintf( fh, 'E%d %d %d %d %d 1\n', i, i, i+1, j, N+1 ) ;

         j = j + 1 ;
      end
   end

   for i = 1:N-1
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
      if ( doProblemA )
         si = sin( 2 * pi * xi ) ;
      else
         si = 1 ;
      end

      trace( sprintf('i: %d, xi: %f, si: %f, H/\\kappa_m = %f', i, xi, si, hAmp/ kappaM ) ) ;
      current = hAmp * deltaX * si * si / kappaM ;
     
      fprintf( fh, 'I%d 0 %d DC %f\n', i, i, current ) ;
   end

   fclose( fh ) ;
end
