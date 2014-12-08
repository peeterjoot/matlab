function [II, JI] = DiodeCurrentAndJacobian( Gd, F, Fbar, D, bdiode, V ) ;
   % DiodeCurrentAndJacobian: Calculate the non-linear current contributions of the diode
   % and its associated Jacobian.

   R = size( D, 1 ) ;
   vSize = size( Gd, 1 ) ;
   II = zeros( vSize, 1 ) ;
   JI = zeros( vSize, vSize ) ;
   twoNplusOne = size( F, 1 ) ;

   for i = 1:size(D, 2)
      E = DiodeExponentialDFT( bdiode{i}, V, R, F, Fbar ) ;
      JE = DiodeExponentialJacobian( bdiode{i}, V, R, F, Fbar ) ;
      d = D( :, i ) ;

      % concatenate the D[]'s and the E's to form II.
      for j = 1:twoNplusOne

         II( 1 + (j - 1) * R: j * R, 1 ) = II( 1 + (j - 1) * R: j * R, 1 ) + d * E( j ) ;

         JI( 1 + (j - 1) * R: j * R, : ) = JI( 1 + (j - 1) * R: j * R, : ) + d * JE( j, : ) ;
      end
   end

end
