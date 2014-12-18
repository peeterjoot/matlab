function diodeLineToTaylorSeries( label, n1, n2, io, vt, N )
   % take a line like:
   %
   % D1 2 3 10e-12 25e-3
   %
   % and produce an equivalent Nth order Taylor expansion.

   invfactorial = 1 ;
   for i = 1:N
      invfactorial =  invfactorial / i ;

      fprintf( 'P%s_%i %d %d %e %e %d\n', label, i, n1, n2, io * invfactorial, vt, i ) ;
   end
end
