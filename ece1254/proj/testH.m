function testH(filename)

   if ( nargin < 1 )
      filename = 'tests/diode1.netlist' ;
   end

   [G, C, B, angularVelocities, D, bdiode, xnames] = NodalAnalysis( filename ) ;

%disp( 'G, C, B, D' ) ;
%   full( G ) 
%   full( C ) 
%   full( B ) 
%   full( D )

   N = 1 ;
   % \nu = 7 is hardcoded in all these tests/*.netlist AC sources:
   omega = 2 * pi * 7 ;

%   xnames 

   [Gd, Vnames, I, F, Fbar] = HarmonicBalance( G, C, B, angularVelocities, D, bdiode, xnames, N, omega ) ;

%   angularVelocities
%   real(Gd)
%   imag(Gd)
%   real(I)
%   imag(I)
%   Vnames

   R = size( xnames, 1 ) ;

   V = rand( size( Gd, 1 ), 1 ) ;
   II = zeros( size( V ) ) ;
   twoNplusOne = size( F ) ;

   % move to helper function:
   for i = 1:size(D, 2)
      E = DiodeExponentialDFT( bdiode{i}, V, R, F, Fbar ) ;
      JE = DiodeExponentialJacobian( bdiode{i}, V, R, F, Fbar ) ;
%full(E)
%full(JE)
      d = D( :, i ) ;

      % concatenate the D[]'s and the E's to form II.
      for j = 1:twoNplusOne

         II( 1 + (j - 1) * R: j * R, 1 ) = II( 1 + (j - 1) * R: j * R, 1 ) + d * E( j ) ;
      end
   end

%   II
%   V = Gd\(I + II) ;
%Gd
%   Fbar * V /twoNplusOne
end   
