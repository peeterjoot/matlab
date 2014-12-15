function nonlinearMatrices = DiodeNonVdependent( p )
   % DiodeNonVdependent: V independent parts of the diode current and Jacobian calculations.

   bdiode = p.bdiode ;

   S = length( bdiode ) ;
   traceit( sprintf( 'entry.  S = %d', S ) ) ;

   vSize = size( p.Y, 1 ) ;
   twoNplusOne = size( p.F, 1 ) ;
   nonlinearMatrices = cell( S, 1 ) ;

   for i = 1:S
traceit( sprintf('%d', i ) ) ;
      dio = bdiode{i} ;

      D = zeros( vSize, twoNplusOne, 'like', sparse(1) ) ;

      d = p.D( :, i ) ;

      for j = 1:twoNplusOne
         D( 1 + (j-1) * S : j * S, j ) = d ;
      end

      A = dio.io * D * p.Finv ;

      H = p.F * D.' /dio.vt ;

      % don't really have to cache D, but keep for debug for now.
      nonlinearMatrices{ i } = struct( 'D', D, 'H', H, 'A', A ) ;
   end

   traceit( 'exit' ) ;
end
