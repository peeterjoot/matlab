function [discreteTimes, v, s] = plotSolutionIterations( deltaTinNanoseconds, withBE )

filename = 'a.netlist' ;
cachefilename = 'a.mat' ;

if ( exist( cachefilename, 'file' ) )
   load( cachefilename ) ;
else
   %[r, endpoints] = generateNetlist( filename, [0.05 ; 0.05] ) ;
   [r, endpoints] = generateNetlist( filename ) ;

   [G, C, b, xnames] = NodalAnalysis( filename ) ;

   save( cachefilename, 'G', 'C', 'b', 'xnames', 'endpoints' ) ;
end

deltaTinSeconds = deltaTinNanoseconds * 1e-9 ;

if ( withBE )
   lupCachePath = sprintf( 'be.LUPdeltaTps_%d.mat', deltaTinNanoseconds * 1000 ) ;
else
   lupCachePath = sprintf( 'tr.LUPdeltaTps_%d.mat', deltaTinNanoseconds * 1000 ) ;
end

if ( exist( lupCachePath, 'file' ) )
   load( lupCachePath ) ;
else
   cOverDeltaT = C/ deltaTinSeconds ;

   if ( withBE )
      A = cOverDeltaT + G ;

      % prep for solving A\r
      [ L, U, P ] = lu( A ) ;

      save( lupCachePath, 'A', 'cOverDeltaT', 'L', 'U', 'P' ) ;
   else
      cOverDeltaT = 2 * cOverDeltaT ;

      B = cOverDeltaT - G ;
      A = cOverDeltaT + G ;

      [ L, U, P ] = lu( A ) ;

      save( lupCachePath, 'A', 'B', 'L', 'U', 'P' ) ;
   end
end

if ( withBE )
   voltageCachePath = sprintf( 'be.VoltageDeltaTps_%d.mat', deltaTinNanoseconds * 1000 ) ;
else
   voltageCachePath = sprintf( 'tr.VoltageDeltaTps_%d.mat', deltaTinNanoseconds * 1000 ) ;
end

if ( exist( voltageCachePath, 'file' ) )
   load( voltageCachePath ) ;
else
   s = [] ;

   x = zeros( size(b) ) ;

   % for the plot or the error calculations, only the voltages at the chip load node have to be saved
   e = endpoints( 1 ) ;
   s( end + 1 ) = x( e ) ;

   vv = 0 ;
   bv = 0 ;
   discreteTimes = [0:deltaTinSeconds:5e-9] ;

   v = vclock( discreteTimes ) ;

   if ( withBE )
      i = 1 ;
      for t = discreteTimes(2:end)
         newV = v( i ) ;

         if ( newV ~= vv )
            vv = newV ;
            bv = b * vv ;
         end

         r = P * (cOverDeltaT * x + bv) ;
         y = L\r ;
         x = U\y ;
         s( end + 1 ) = x( e ) ;

         i = i + 1 ;
      end
   else
      i = 1 ;
      lastV = vv ;
      for t = discreteTimes(2:end)
         newV = v( i ) ;

         c = b * ( newV + lastV ) ;
         lastV = newV ;

         r = P * (B * x + c) ;
         y = L\r ;
         x = U\y ;
         s( end + 1 ) = x( e ) ;

         i = i + 1 ;
      end
   end

   save( voltageCachePath, 'discreteTimes', 'v', 's' ) ;
end
