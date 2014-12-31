function bucketStreamlines()
   % foo: docs go here.

   n = 25 ;
   nr = 10 ;
   theta = [0: 2 * pi / n : 2 * pi ] ;

   close all ;
   f = figure ;
   hold on ;
   for r = [0:1/nr:1]
      x = r * cos(theta) ;
      y = r * sin(theta) ;

      ux = -y ;
      uy = x ;

      quiver( x, y, ux, uy ) ;
   end

   xlabel( 'x' ) ;
   ylabel( 'y' ) ;
   axis square ;

   [fileExtension, savePlot] = saveHelper() ;

   savePlot( f, sprintf('bucketStreamlinesFig1.%s', fileExtension) ) ;
end
