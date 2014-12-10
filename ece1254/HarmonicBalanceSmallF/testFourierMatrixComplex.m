function testFourierMatrixComplex( N )
   % Verify FourierMatrixComplex( N ), produced with vectorized code, against dumb
   % programmatic loop construction method.
   % N is the number of Harmonics to be used
   %
   r = -N:N ;
   twoNplusOne = 2*N + 1 ;

   F2 = zeros( twoNplusOne, twoNplusOne ) ;
   alpha = exp( (2 * pi * j)/twoNplusOne ) ;
   for n = 1:twoNplusOne
      for m = 1:twoNplusOne
          F2( n, m ) = alpha^( r(n)*r(m) ) ;
      end
   end

   F = FourierMatrixComplex( N ) ;

   disp( 'difference: (expect zeroish)' ) ;
   max(max(F2 - F))

end
