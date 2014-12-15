function [II, JI] = DiodeCurrentAndJacobian( in, V )
   % DiodeCurrentAndJacobian: Calculate the non-linear current contributions of the diode
   % and its associated Jacobian.

   S = length( in.nonlinearMatrices ) ;
   %traceit( sprintf( 'entry.  S = %d', S ) ) ;

   vSize = size( in.Y, 1 ) ;
   twoNplusOne = size( in.F, 1 ) ;

   II = zeros( vSize, 1 ) ;
   JI = zeros( vSize, vSize ) ;

   for i = 1:S
      H = in.nonlinearMatrices{ i }.H ;

      ee = zeros( twoNplusOne, 1 ) ;
      he = zeros( twoNplusOne, vSize ) ;

      for j = 1:twoNplusOne
         ht = H( j, : ) ;
         ee( j ) = exp( ht * V ) ;
         he( j, : ) = ht * ee( j ) ;
      end

      II = II + in.nonlinearMatrices{ i }.A * ee ;
      JI = JI + in.nonlinearMatrices{ i }.A * he ;
   end

   %traceit( 'exit' ) ;
end
