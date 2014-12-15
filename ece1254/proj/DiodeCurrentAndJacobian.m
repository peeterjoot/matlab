function [II, JI] = DiodeCurrentAndJacobian( in, V )
   % DiodeCurrentAndJacobian: Calculate the non-linear current contributions of the diode
   % and its associated Jacobian.

   S = length( in.bdiode ) ;
   traceit( sprintf( 'entry.  S = %d', S ) ) ;

   vSize = size( in.Y, 1 ) ;
   twoNplusOne = size( in.F, 1 ) ;

   II = zeros( vSize, 1 ) ;
   JI = zeros( vSize, vSize ) ;

   for i = 1:S
      ee = zeros( twoNplusOne, 1 ) ;
      he = zeros( twoNplusOne, vSize ) ;

      for i = 1:twoNplusOne
         ht = in.bdiode{i}.H(i, :) ;
         ee(i) = exp( ht * V ) ;
         he(i, :) = ht * ee( i ) ;
      end

      II = II + in.bdiode{i}.A * ee ;
      JI = JI + in.bdiode{i}.A * he ;
   end

   traceit( 'exit' ) ;
end
