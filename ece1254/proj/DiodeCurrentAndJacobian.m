function [II, JI] = DiodeCurrentAndJacobian( in, V )
   % DiodeCurrentAndJacobian: Calculate the non-linear current contributions of the diode
   % and its associated Jacobian.

   R = length( in.bdiode ) ;
   traceit( sprintf( 'entry.  R = %d', R ) ) ;

   vSize = size( in.Y, 1 ) ;
   II = zeros( vSize, 1 ) ;
   JI = zeros( vSize, vSize ) ;
   twoNplusOne = size( in.F, 1 ) ;

   for i = 1:R
      E = DiodeExponentialDFT( in.bdiode{i}, V, R, in.F, in.Finv ) ;
      JE = DiodeExponentialJacobian( in.bdiode{i}, V, R, in.F, in.Finv ) ;
      d = in.D( :, i ) ;

      % concatenate the D[]'s and the E's to form II.
      for j = 1:twoNplusOne

         II( 1 + (j - 1) * R: j * R, 1 ) = II( 1 + (j - 1) * R: j * R, 1 ) + d * E( j ) ;

         JI( 1 + (j - 1) * R: j * R, : ) = JI( 1 + (j - 1) * R: j * R, : ) + d * JE( j, : ) ;
      end
   end

   traceit( 'exit' ) ;
end
