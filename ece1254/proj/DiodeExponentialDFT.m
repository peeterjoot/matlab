function E = DiodeExponentialDFT( d, V, R, F, Finv )
   % DiodeExponentialDFT: given a diode struct descriptor, generate the DFT
   % calculation associated with a specific value of V.
   %
   % This calculates:
   %
   %    \vec{E} = (1/(2 N + 1)) \bar{F} * exp( F * (V^m - V^n)/V_T ), where m = d.vp, and n = d.vn
   %
   % One or more of (n,m) may be zero if the diode is connected to ground.
   %
   % parameters:
   %
   %  d:    [struct]:  struct( 'type', 'exp', 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
   %  V:    [vector]:  The whole DFT coordinate vector V of size: (R * (2 N + 1)) x 1.
   %  R:    [integer]: the number of unknowns in the time domain equations.
   %  F:    [matrix]:  (2N + 1) DFT matrix.
   %  Finv: [matrix]:  conj(F)/(2 N + 1)

   traceit( sprintf( 'entry. R,io,vp,vn,vt = %d,%e,%d,%d,%e', R, d.io, d.vp, d.vn, d.vt ) ) ;

   if ( d.vp )
      diffV = V( d.vp : R : end ) ;

      if ( d.vn )
         diffV = diffV - V( d.vn : R : end ) ;
      end
   else
      diffV = - V( d.vn : R : end ) ;
   end

   diffV = diffV/d.vt ;

   vTimeDomain = F * diffV ;
   ExpV = exp( vTimeDomain ) ;

   E = Finv * ExpV ;

   traceit( sprintf( 'exit' ) ) ;
end
