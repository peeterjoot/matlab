function p2( )
   % p2: Problem 2.  Code to confirm the zeros numerically, and to plot the absolute array factor.

   kd = 2 * pi * (1/2) ;

   theta = 0:0.01:pi ;
   thetaZeros = [0, pi/3, 2 * pi/3 ] ;

   expValues = exp( 1j * ( kd * cos( theta ) ) ) ;
   expValuesZ = exp( 1j * ( kd * cos( thetaZeros ) ) ) ;

   af = abs((1 + expValues + expValues.^2 + expValues.^3)/4) ;
   afz = (1 + expValuesZ + expValuesZ.^2 + expValuesZ.^3)/4 ;

   % This is to verify my hand expansion of the array factor in terms of cosines
   % (looks like I could have also used a sinc expansion by summing first).
   %
   cosValues = abs( cos( kd * cos( theta )/2 ) + cos( 3 * kd * cos( theta )/2 ) )/2 ;
   cosValuesZ = (cos( kd * cos( thetaZeros )/2 ) + cos( 3 * kd * cos( thetaZeros )/2 ))/2 ;

   f = figure ;

   if ( 0 )
      polar( theta, af ) ;
   else
      polar( theta, cosValues ) ;
   end

% manual unit test: confirm the zeros:
   if ( 0 )
      disp( afz )
      disp( cosValuesZ )
   end

   [fileExtension, savePlot] = saveHelper() ;

   saveName = sprintf( 'ps4p2PlotFig1.%s', fileExtension ) ;

   savePlot( f, saveName ) ;
end
