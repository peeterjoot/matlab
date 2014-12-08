function E = DiodeExponentialDFT( d, V, R, F, Fbar )
   % DiodeExponentialDFT: given a diode struct descriptor, generate the DFT 
   % calculation associated with a specific value of V.
   % 
   % This calculates:
   %
   %    \vec{E} = \bar{F} * exp( F * (V^m - V^n)/V_T ), where m = d.vp, and n = d.vn
   % 
   % one or more of n, or m may be zero if the diode is connected to ground.
   % 
   % parameters:
   % 
   %  d:    [struct]:  struct( 'type', 'exp', 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
   %  V:    [vector]:  The whole DFT coordinate vector V of size: (R * (2 N + 1)) x 1.
   %  R:    [integer]: the number of unknowns in the time domain equations.
   %  F:    [matrix]:  2N + 1 DFT matrix.
   %  Fbar: [matrix]:  conj(F)

   if ( d.vn )
      vn = - V( d.vn : R : end ) ;
   end

   if ( d.vp )
      diffV = V( d.vp : R : end ) ;

      if ( d.vn )
         diffV = diffV - V( d.vn : R : end ) ;
      end
   else
      diffV = - V( d.vn : R : end ) ;
   end

   diffV = diffV/d.vt ;

   twoNplusOne = size( F, 1 ) ;
   vTimeDomain = F * diffV ;
   ExpV = exp( vTimeDomain ) ;

   E = Fbar * ExpV / twoNplusOne ;
end
