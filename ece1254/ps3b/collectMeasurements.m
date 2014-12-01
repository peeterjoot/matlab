function collectMeasurements()

   qs = [1 2 4 10 50 501] ;

if ( 0 )
   figure ;

   for q = qs
      [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, 2000, 10000, 0, 1 ) ;
      hold on ;
      plot( discreteTimes, s ) ;
   end
end

   for q = qs
      [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, 2000, 700, 0, 0 ) ;
      hold on ;
      plot( discreteTimes, s ) ;
   end
end
