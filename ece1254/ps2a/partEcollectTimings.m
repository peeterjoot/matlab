function [N, timingsSolve, timingsLU, timingsCG, itersCG, timingsCGp, itersCGp, sanityChecks] = partEcollectTimings()

timingsSolve = [] ;
timingsLU = [] ;
timingsCG = [] ;
itersCG = [] ;
timingsCGp = [] ;
itersCGp = [] ;
sanityChecks = [] ;

% sample timing data a couple times and take the min as representative
nSamples = 3 ;
N = [ 8 16 ] ;
%32 64 128 ] ;
epsilon = eps * 100 ;

for i = N
   nodalVarsFile = sprintf( 'nodal.%d.mat', i ) ;
   load( nodalVarsFile ) ;

   tmp = [] ;
   for k = 1:nSamples
      tic ;
         r = G\b ;
      delta = toc ;
      tmp(end+1) = delta ;
   end
   timingsSolve(end+1) = min(tmp) ;

   % my LU is too slow (even without pivots which don't seem required for this problem) for large N.
   if ( i < 64 )
      tmp = [] ;
      for k = 1:nSamples
         tic ;
            [L, U] = noPivotLU( G, epsilon ) ;
            y = forwardSubst( L, b, epsilon ) ;
            s = backSubst( U, y, epsilon ) ;
         delta = toc ;
         tmp(end+1) = delta ;
      end
      timingsLU(end+1) = min(tmp) ;
   end

   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [t, stats] = conjugateGradientQuarteroniPrecond( G, b, [], 1e-3 ) ;
      delta = toc ;
      tmp(end+1) = delta ;
   end
   itersCG(end+1) = stats(end) ;
   timingsCG(end+1) = min(tmp) ;

   P = tridiagonal( G ) ;
   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [u, stats] = conjugateGradientQuarteroniPrecond( G, b, P, 1e-3 ) ;
      delta = toc ;
      tmp(end+1) = delta ;
   end
   itersCGp(end+1) = stats(end) ;
   timingsCGp(end+1) = min(tmp) ;

   % expect the same solutions:
   sanityChecks(end+1) = [ norm( r - s ) ; norm( r - t ) ; norm( r - u ) ] ;

end
