function f = p1plot( ad )
   % plots: ps4. p1: plot the array factor for a given value of ad.

   
   %%
   % $k d = (2 \pi/\lambda) (\lambda/2) = \pi$
   % 
   kd = 2 * pi * (1/2) ;

   theta = 0:0.01:pi ;

   af = ((1 + exp( 1j * ( kd * cos( theta ) + ad ) )).^2/4) ;

   afabs = abs( af ) ;
%   afsq = af .* conj(af) ;

   f = figure ;

   %polar( theta, afsq ) ;
   polar( theta, afabs ) ;

   f
end
