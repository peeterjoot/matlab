function [ Gprime ] = Gprime( bdiodes, x, Nh, Nm )
   % Gprime This function produces the nonlinear contribution to the Jacobian
   % required to solve a nonlinear circuit using Newton's Method
   %   bdiodes is a cell matrix containing the infromation describing the
   %   location and parameters of all diodes in the circuit
   %   x is the vector of all unknown quantities
   %   Nh is the number of harmonics used in the analysis
   %   Nm is the number of physical unknowns of the MNA

   N = length(bdiodes) ;
   F = FourierMatrix(Nh,Nm) ;

   dDiode = @(v,io,Vt) (io/Vt)*(exp(v/Vt)) ;

   % Generate the Jacobian corresponding to a single circuit for each time step
   % then combine them as a block column matrix. This form allows the Fourier
   % matrix to be used in obtaining the DFT

   gprime = zeros(Nm*(2*Nh+1)) ;

   % for each time step
   for j = 0:2*Nh ;
       gprimecell = zeros(Nm) ;

       % for each diode
       for i = 1:N ;
           d = bdiodes{i} ;

           n1 = d.vp ;
           n2 = d.vn ;

           io = abs(d.io) ;
           Vt = abs(d.vt) ;
           v = 0 ;

           if (n1)
               v = v + x( n1 + j*Nm ) ;
           end

           if (n2)
               v = v - x( n2 + j*Nm ) ;
           end

           dg = dDiode(v,io,Vt) ;

           % insert the stamp:
           if ( n1 )
               gprimecell( n1, n1 ) = gprimecell( n1, n1 ) + dg ;
               if ( n2 )
                   gprimecell( n1, n2 ) = gprimecell( n1, n2 ) - dg ;
                   gprimecell( n2, n1 ) = gprimecell( n2, n1 ) - dg ;
               end
           end
           if ( n2 )
               gprimecell( n2, n2 ) = gprimecell( n2, n2 ) + dg ;
           end
       end

       corner = 1 + j*Nm ;


       gprime(corner:corner+Nm-1,corner:corner+Nm-1) = gprimecell ;

   end

   Gprime = F\(gprime*F) ;

end
