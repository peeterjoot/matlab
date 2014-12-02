function [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, tn, maxT, withBE, withSine, withPrima )
%
% Calculate and cache the netlist file for the circuit and the associated MNA equations.
% Calculate the BE or TR discretized solution for a given timestep.
%
% This requires plotFreqPartC( 500, 501, 1 ) to have been run first.
%
% allowed values of q include:
%
% q = [1 2 4 10 50 501] ;
%
% parameters:
%
% q         [integer]:        order of the modal reduction
% tn        [integer > 0]:    number of timestep intervals to use.
% maxT      [double > 0]:     end of time for iterations.
% withBe    [boolean]:        specify 1,0 for BE or TR iteration methods respectively.
% withSine  [boolean]:        specify 1,0 for sine or unit step driver input respectively.
% withPrima [boolean]:        specify 1,0 for modal or prima reduction respectively.
% 
% outputs:
%
% discreteTimes  [array, double]: the times at which the output is calculated.
% v              [array, double]: values of the driving function at each of the times above.
% s              [array, double]: solutions at each of the times above.
% iterationTimes [array, double]: cpu usage measurements for a few repeated attempts of the time step calculations.

deltaT = maxT/tn ;

n = 500 ;
where = 501 ;
withOpenCircuitEndpoints = 1 ;



% indexed by withPrima
method = { 'modal', 'prima' } ;

if ( (q == 501) || withPrima )
   nodalCacheName = sprintf('nodal%d_%d_%d.mat', n, where, withOpenCircuitEndpoints ) ;
   load( nodalCacheName ) ;

   b = bu ;
else
   qCache = sprintf('modalReduction_q%d_n%d_w%d_o%d.mat', q, n, where, withOpenCircuitEndpoints ) ;

   load( qCache ) ;

   G = Gq ;
   C = Cq ;
   b = bq ;
   L = Lq ;
end

if ( withPrima && (q ~= 501) )
   qPrimaCache = sprintf('primaReduction_q%d_n%d_w%d_o%d.mat', q, n, where, withOpenCircuitEndpoints ) ;

   if ( exist( qPrimaCache, 'file' ) )
      load( qPrimaCache ) ;
   else
      [Gq, Cq, bq, Lq, ~] = prima( G, C, bu, L, q ) ;

      cInv = inv( Cq ) ;
      Gq = cInv * Gq ;
      bq = cInv * bq ;
      Cq = eye( size(Cq) ) ;

      [V, Gq] = sorteig( Gq, 'descend' ) ;
   
      bq = inv(V) * bq ;
      Lq = V.' * Lq ;

      save( qPrimaCache, 'Gq', 'Cq', 'bq', 'Lq' ) ;
   end

   G = Gq ;
   C = Cq ;
   b = bq ;
   L = Lq ;
end

if ( withBE )
   lupCachePath = sprintf( 'be.%s_LUP_q%d_Tn_%d_maxT%d_Sine%d.mat', method{withPrima+1}, q, tn, maxT, withSine ) ;
else
   lupCachePath = sprintf( 'tr.%s_LUP_q%d_Tn_%d_maxT%d_Sine%d.mat', method{withPrima+1}, q, tn, maxT, withSine ) ;
end

if ( exist( lupCachePath, 'file' ) )
   load( lupCachePath ) ;
else
   cOverDeltaT = C/ deltaT ;

   if ( withBE )
      F = cOverDeltaT + G ;

      % prep for solving F\r
      [ lowerFactor, upperFactor, permuteFactor ] = lu( F ) ;

      save( lupCachePath, 'F', 'cOverDeltaT', 'lowerFactor', 'upperFactor', 'permuteFactor' ) ;
   else
      cOverDeltaT = 2 * cOverDeltaT ;

      B = cOverDeltaT - G ;
      F = cOverDeltaT + G ;

      [ lowerFactor, upperFactor, permuteFactor ] = lu( F ) ;

      save( lupCachePath, 'F', 'B', 'lowerFactor', 'upperFactor', 'permuteFactor' ) ;
   end
end

if ( withBE )
   outputCachePath = sprintf( 'be.%s_Output_q%d_Tn_%d_maxT%d_Sine%d.mat', method{withPrima+1}, q, tn, maxT, withSine ) ;
else
   outputCachePath = sprintf( 'tr.%s_Output_q%d_Tn_%d_maxT%d_Sine%d.mat', method{withPrima+1}, q, tn, maxT, withSine ) ;
end

if ( exist( outputCachePath, 'file' ) )
   load( outputCachePath ) ;
else
   numCpuMeasurementSamples = 3 ;
   %numCpuMeasurementSamples = 1 ;
   iterationTimes = [] ;

   % repeate the iteration calculation a couple times to measure the cpu cost (part e).  Then cache those costs as well as the solution
   % for later reference.
   %
   for k = [1:numCpuMeasurementSamples]
      tic ;

      x = zeros( size(b) ) ;

      s = [] ;
      s(end+1) = 0 ;

      vv = 0 ;
      bv = 0 ;
      discreteTimes = [0:deltaT:maxT] ;

      if ( withSine )
         v = sin( 0.01 * discreteTimes ) ;
      else
         v = ones( tn + 1, 1 ) ;
      end

      if ( withBE )
         i = 1 ;
         for t = discreteTimes(2:end)
            newV = v( i ) ;

            if ( newV ~= vv )
               vv = newV ;
               bv = b * vv ;
            end

            r = permuteFactor * (cOverDeltaT * x + bv) ;
            y = lowerFactor\r ;
            x = upperFactor\y ;
            s( end + 1 ) = L.' * x ;

            i = i + 1 ;
         end
      else
         i = 1 ;
         lastV = vv ;
         for t = discreteTimes(2:end)
            newV = v( i ) ;

            c = b * ( newV + lastV ) ;
            lastV = newV ;

            r = permuteFactor * (B * x + c) ;
            y = lowerFactor\r ;
            x = upperFactor\y ;
            s( end + 1 ) = L.' * x ;

            i = i + 1 ;
         end
      end
      iterationTimes(end+1) = toc ;
   end

   save( outputCachePath, 'discreteTimes', 'v', 's', 'iterationTimes' ) ;
end
