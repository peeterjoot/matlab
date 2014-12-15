function [II, JI] = DiodeCurrentAndJacobian( in, V )
   % DiodeCurrentAndJacobian: Calculate the non-linear current contributions of the diode
   % and its associated Jacobian.

   S = length( in.bdiode ) ;
   traceit( sprintf( 'entry.  S = %d', S ) ) ;

   vSize = size( in.Y, 1 ) ;
   twoNplusOne = size( in.F, 1 ) ;

   for i = 1:S
      D = zeros( vSize, twoNplusOne, 'like', sparse(1) ) ;
      d = in.D( :, i ) ;

      for i = 1:twoNplusOne
         D( 1 + (i-1) * S : i * S, i ) = d ;
      end

      A = in.bdiode{i}.io * D * in.Finv ;

      H = F * D.' /in.bdiode{i}.vt ;

      in.bdiode{i}.D = D ; % don't really have to cache.  Keep for debug for now.
      in.bdiode{i}.A = A ;
      in.bdiode{i}.H = H ;
   end

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
