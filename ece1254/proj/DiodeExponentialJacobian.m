function JE = DiodeExponentialJacobian( d, V, R, F, Finv )
   % DiodeExponentialJacobian: This calculates the Jacobian of
   %
   %    \vec{E} = (1/(2 N + 1)) \bar{F} * exp( F * (V^m - V^n)/V_T ), where m = d.vp, and n = d.vn
   %
   % One or more of n, or m may be zero if the diode is connected to ground.
   %
   % parameters:
   %
   %  d:    [struct]:  struct( 'type', 'exp', 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
   %  V:    [vector]:  The whole DFT coordinate vector V of size: (R * (2 N + 1)) x 1.
   %  R:    [integer]: the number of unknowns in the time domain equations.
   %  F:    [matrix]:  (2N + 1) DFT matrix.
   %  Finv: [matrix]:  conj(F)/(2 N + 1)

   traceit( sprintf( 'entry' ) ) ;

   twoNplusOne = size( F, 1 ) ;
   vSize = size( V, 1 ) ;
   JE = zeros( twoNplusOne, vSize, 'like', sparse(1) ) ;

   m = d.vp ;
   n = d.vn ;
   vt = d.vt ;
   kronDel = @(j, k) j==k ;

%enableTrace() ;
   for r = 1:twoNplusOne
      for s = 1:vSize
         for a = 1:twoNplusOne
            for b = 1:twoNplusOne
               u = m + (b - 1) * R ;
               v = n + (b - 1) * R ;

%traceit( sprintf('r, s, a, b, u, v, m, n = %d, %d, %d, %d, %d, %d, %d, %d', r, s, a, b, u, v, m, n ) ) ;

% m != 0 check is not good enough.  Can end up with u = 0 with b = 1 && m = 0.  also looks like V( u ) gets evaluated first.
               arg = ( m && u ) * V( u ) - ( n && v ) * V( v ) ;
               delta = (m ~= 0) * kronDel( s, u ) - ( n ~= 0 ) * kronDel( s, v ) ;
               expValue = exp( F(a, b) * arg / vt ) ;

%traceit( sprintf('arg, delta, exp() = %e, %d, %e', arg, delta, expValue ) ) ;

               JE(r, s) = JE(r, s) + Finv(r, a) * F(a, b) * expValue * delta ;
            end
         end
      end
   end

   JE = JE/vt ;

   traceit( sprintf( 'exit' ) ) ;
end
