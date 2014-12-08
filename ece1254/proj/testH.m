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
   %V = zeros( size( Gd, 1 ), 1 ) ;

   [II, JI] = DiodeCurrentAndJacobian( Gd, F, Fbar, D, bdiode, V ) ;
   J = Gd - JI ;
%J
%inv(J)
%   II
%   V = Gd\(I + II) ;
%Gd
%   Fbar * V /twoNplusOne
end   
