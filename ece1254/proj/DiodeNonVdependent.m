function nonlinearMatrices = DiodeNonVdependent( p )
   % DiodeNonVdependent: V independent parts of the diode current and Jacobian calculations.

   nonlinear = p.nonlinear ;

   S = length( nonlinear ) ;
   dsz = size( p.D, 1 ) ;
   traceit( sprintf( 'entry.  S = %d, dsz = %d', S, dsz ) ) ;

   vSize = size( p.Y, 1 ) ;
   twoNplusOne = size( p.F, 1 ) ;
   nonlinearMatrices = cell( S, 1 ) ;

   for i = 1:S
%traceit( sprintf('%d', i ) ) ;
      dio = nonlinear{i} ;

      innerD = zeros( vSize, twoNplusOne, 'like', sparse(1) ) ;
      outerD = innerD ;

      vecInnerD = zeros( dsz, 1, 'like', innerD ) ;
      vecOuterD = p.D( :, i ) ;

      % for Ennnn non-linear terms the selector of the vp/vn components differs from the scale of the non-linear contribution:
      if ( dio.vp )
         vecInnerD( dio.vp ) = 1 ;
      end
      if ( dio.vn )
         vecInnerD( dio.vn ) = -1 ;
      end

      for j = 1:twoNplusOne
         innerD( 1 + (j-1) * dsz : j * dsz, j ) = vecInnerD ;
         outerD( 1 + (j-1) * dsz : j * dsz, j ) = vecOuterD ;
      end

      A = dio.io * outerD * p.Finv ;

      H = p.F * innerD.' /dio.vt ;

      % don't really have to cache innerD,outerD but keep for debug for now.
      nonlinearMatrices{ i } = struct( 'innerD', innerD, 'outerD', outerD, 'H', H, 'A', A ) ;
   end

   traceit( 'exit' ) ;
end
