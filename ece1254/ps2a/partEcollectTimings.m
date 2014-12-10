function [N, timingsSolve, timingsLU, timingsCG, itersCG, timingsCGp, itersCGp, eTimingsSolve, eTimingsLU, eTimingsCG, eTimingsCGp, timingsCG2, itersCG2, eTimingsCG2, timingsCGp2, eTimingsCGp2, itersCGp2] = partEcollectTimings()
% collect timing data for each of the part (e) solution methods.

timingsSolve = [] ;
timingsLU = [] ;
timingsCG = [] ;
timingsCG2 = [] ;
timingsCGp = [] ;
timingsCGp2 = [] ;

eTimingsSolve = [] ;
eTimingsLU = [] ;
eTimingsCG = [] ;
eTimingsCG2 = [] ;
eTimingsCGp = [] ;
eTimingsCGp2 = [] ;

itersCG = [] ;
itersCG2 = [] ;
itersCGp = [] ;
itersCGp2 = [] ;

% sample timing data a couple times:
nSamples = 3 ;

N = [ 8 16 32 64 128 ] ;
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
   timingsSolve(end+1) = mean(tmp) ;
   eTimingsSolve(end+1) = max(tmp) - min(tmp) ;

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

         % norm( r - s )
      end
      timingsLU(end+1) = mean(tmp) ;
      eTimingsLU(end+1) = max(tmp) - min(tmp) ;
   end

   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [t, stats, residuals] = conjugateGradientQuarteroniPrecond( G, b, [], 1e-3 ) ;
      delta = toc ;
      tmp(end+1) = delta ;

      % norm( r - t )
   end
   itersCG(end+1) = stats(end) ;
   timingsCG(end+1) = mean(tmp) ;
   eTimingsCG(end+1) = max(tmp) - min(tmp) ;

   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [v, stats] = conjugateGradientPainlessB2( G, b, [], 1e-3 ) ;
      delta = toc ;
      tmp(end+1) = delta ;

      % norm( r - v )
   end
   itersCG2(end+1) = stats(end) ;
   timingsCG2(end+1) = mean(tmp) ;
   eTimingsCG2(end+1) = max(tmp) - min(tmp) ;

   P = tridiagonal( G ) ;
   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [u, stats, residuals] = conjugateGradientQuarteroniPrecond( G, b, P, 1e-3 ) ;
      delta = toc ;
      tmp(end+1) = delta ;

      % norm( r - u )
   end
   itersCGp(end+1) = stats(end) ;
   timingsCGp(end+1) = mean(tmp) ;
   eTimingsCGp(end+1) = max(tmp) - min(tmp) ;

   tmp = [] ;
   for k = 1:nSamples
      tic ;
         [w, stats, residuals] = conjugateGradientQuarteroniPrecond( G, b, P, 1e-3, 0 ) ;
      delta = toc ;
      tmp(end+1) = delta ;

      % norm( r - w )
   end
   itersCGp2(end+1) = stats(end) ;
   timingsCGp2(end+1) = mean(tmp) ;
   eTimingsCGp2(end+1) = max(tmp) - min(tmp) ;
end

nLU = size(timingsLU, 2) ;
figure ;
errorbar(N(1:nLU), timingsLU, eTimingsLU) ;
xlabel( 'N' ) ;
ylabel( 'LU (s)' ) ;

figure ;
p1 = plot( N, itersCG, 'r.-' ) ;
hold on ;
%p2 = plot( N, itersCG2, '.--' ) ;
%hold on ;
p3 = plot( N, itersCGp, 'b.:' ) ;
xlabel( 'N' ) ;
ylabel( 'Iterations' ) ;
%legend( [p1;p2;p3], 'CG', 'CG (optimized)', 'CG (preconditioned)') ;
legend( [p1;p3], 'CG', 'CG (preconditioned)') ;

% http://stackoverflow.com/questions/17329999/legend-in-line-plot-of-matrix-with-hold-on
figure ;
p1 = errorbar( N, timingsCG, eTimingsCG, 'r.-' ) ;
hold on ;
p2 = errorbar( N, timingsCG2, eTimingsCG2, '.--' ) ;
hold on ;
p3 = errorbar( N, timingsCGp, eTimingsCGp, 'b.:' ) ;
xlabel( 'N' ) ;
ylabel( 'Solution time (s)' ) ;
legend( [p1;p2;p3], 'CG', 'CG (optimized)', 'CG (preconditioned)') ;

figure ;
p1 = errorbar( N, timingsCG, eTimingsCG, 'r.-' ) ;
hold on ;
p2 = errorbar( N, timingsCG2, eTimingsCG2, '.--' ) ;
hold on ;
p3 = errorbar( N, timingsCGp, eTimingsCGp, 'b.:' ) ;
hold on ;
p4 = errorbar( N, timingsCGp2, eTimingsCGp2, 'b.-' ) ;
xlabel( 'N' ) ;
ylabel( 'Solution time (s)' ) ;
legend( [p1;p2;p3;p4], 'CG', 'CG (optimized)', 'CG (preconditioned)', 'CG (preconditioned, LU)') ;

figure ;
p1 = errorbar( N, timingsCG, eTimingsCG, 'r.-' ) ;
hold on ;
p3 = errorbar( N, timingsCGp, eTimingsCGp, '.--' ) ;
xlabel( 'N' ) ;
ylabel( 'Solution time (s)' ) ;
legend( [p1;p3], 'CG', 'CG (preconditioned)') ;
