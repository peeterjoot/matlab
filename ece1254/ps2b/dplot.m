function dplot()

% this diode function doesn't plot easily.  somewhere just after 0.28 it shoots up
%x = -0.01:0.1:0.29 ;
%f = diode( x ) ;
%figure ;
%plot( x, f )
%
%x = -0.01:0.1:0.28 ;
%f = diode( x ) ;
%figure ;
%plot( x, f )

x = 0.18:0.01:0.26 ;
f = diode( x ) ;
figure ;
plot( x, f )

x = 0.16:0.01:0.19 ;
f = diode( x ) ;
figure ;
plot( x, f )
