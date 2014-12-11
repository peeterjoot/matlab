function [ gnl ] = gnl(  bdiodes, x, N , R )
   %GNL This function determines the nonlinear currents of the diodes in bdiodes
   %for the voltages contained in x. (Time domain)
   %
   %   bdiodes is a cell matrix containing the infromation describing the
   %   location and parameters of all diodes in the circuit
   %   x is the vector of all unknown quantities
   %   N is the number of harmonics used in the analysis
   %   R is the number of physical unknowns of the MNA
   % 
   % This should be functionally equivalent to ../HarmonicBalanceSmallF/DiodeExponentialDFT.m
   % except the results of this function are computed in the time domain and returned that way
   % converted to the frequency domain using the big F matrix.
   % The results of DiodeExponentialDFT are returned in the frequency domain, but are not distributed
   % across all the R * ( 2 * N + 1 ).

   %Standard Diode Expression
   %Diode = @( v, io, Vt ) io * ( exp( v/Vt ) - 1 ) ;

   %Reverse Saturation Current Handled in NodalAnalayis as DC source so:
   Diode = @( v, io, Vt ) io * ( exp( v/Vt ) ) ;


   gnl = zeros( R * ( 2 * N + 1 ), 1 ) ;

   %for each harmonic
   for j = 0:2 * N ;
       gnlcell = zeros( R, 1 ) ;
   %for each diode
       for i = 1:length( bdiodes )
           d = bdiodes{i} ;

           n1 = d.vp ;
           n2 = d.vn ;

           io = abs( d.io ) ;
           Vt = abs( d.vt ) ;
           v = 0 ;

           if ( n1 )
               v = v + x( n1 + j * R ) ;
           end

           if ( n2 )
               v = v - x( n2 + j * R ) ;
           end

           id = Diode( v, io, Vt ) ;


           % insert the stamp:
           if ( n1 )
               gnlcell( n1 ) = gnlcell( n1 ) + id ;
           end
           if ( n2 )
               gnlcell( n2 ) = gnlcell( n2 ) - id ;
           end
       end
       blockStart = 1 + j * R ;
       blockEnd = blockStart + R - 1 ;
       gnl( blockStart:blockEnd ) = gnlcell ;
   end
end
