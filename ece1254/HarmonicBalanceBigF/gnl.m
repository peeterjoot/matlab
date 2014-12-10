function [ gnl ] = gnl(  bdiodes, x, Nh , Nm )
   %GNL This function determines the nonlinear currents of the diodes in bdiodes
   %for the voltages contained in x. (Time domain)
   %   
   %   bdiodes is a cell matrix containing the infromation describing the
   %   location and parameters of all diodes in the circuit
   %   x is the vector of all unknown quantities
   %   Nh is the number of harmonics used in the analysis
   %   Nm is the number of physical unknowns of the MNA

   N = length(bdiodes) ;

   %Standard Diode Expression
   %Diode = @(v,io,Vt) io*(exp(v/Vt)-1) ;

   %Reverse Saturation Current Handled in NodalAnalayis as DC source so:
   Diode = @(v,io,Vt) io*(exp(v/Vt)) ;


   gnl = zeros(Nm*(2*Nh+1),1) ;

   %for each harmonic
   for j = 0:2*Nh ;
       gnlcell = zeros(Nm,1) ;
   %for each diode
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

           id = Diode(v,io,Vt) ;


           % insert the stamp:
           if ( n1 )
               gnlcell( n1 ) = gnlcell( n1 ) + id ;
           end
           if ( n2 )
               gnlcell( n2) = gnlcell( n2 ) - id ;
           end
       end
       blockStart = 1 + j*Nm ;
       blockEnd = blockStart + Nm-1 ;
       gnl(blockStart:blockEnd) = gnlcell ;
   end
end
