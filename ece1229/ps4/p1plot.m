function f = p1plot( ad )
   % plots: plot the array factor for a given value of ad.

   kd = 2 * pi * (1/2) ;

   theta = 0:0.01:pi ;

   af = ((1 + exp( -1j * ( kd * cos( theta ) + ad ) )).^2/4) ;

   afabs = abs( af ) ;
%   afsq = af .* conj(af) ;

   f = figure ;

   %polar( theta, afsq ) ;
   polar( theta, afabs ) ;

   f
end
