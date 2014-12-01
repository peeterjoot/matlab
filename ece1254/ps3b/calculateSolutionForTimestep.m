function [discreteTimes, v, s, iterationTimes] = calculateSolutionForTimestep( q, deltaT, maxT, withBE )
%
% Calculate and cache the netlist file for the circuit and the associated MNA equations.
% Calculate the BE or TR discretized solution for a given timestep.
%
% This requires plotFreqPartC( 500, 501, 1 ) to have been run first.

n = 500 ;
where = 501 ;
withOpenCircuitEndpoints = 1 ;

if ( q == 501 )
   nodalCacheName = sprintf('nodal%d_%d_%d.mat', n, where, withOpenCircuitEndpoints ) ;
   load( nodalCacheName ) ;

   b = bu ;
else
   qCache = sprintf('modalReduction_q%d_n%d_w%d_o%d.mat', q, n, where, withOpenCircuitEndpoints ) ;

   load( qCache ) ;
   G = GG ;
   C = CC ;
   b = bb ;
   L = LL ;
end

%if ( withBE )
%   lupCachePath = sprintf( 'be.LUPdeltaTps_%d.mat', deltaT * 1000 ) ;
%else
%   lupCachePath = sprintf( 'tr.LUPdeltaTps_%d.mat', deltaT * 1000 ) ;
%end

%if ( exist( lupCachePath, 'file' ) )
%   load( lupCachePath ) ;
%else
   cOverDeltaT = C/ deltaT ;

   if ( withBE )
      F = cOverDeltaT + G ;

      % prep for solving F\r
      [ luFL, luFU, luFP ] = lu( F ) ;

      %save( lupCachePath, 'F', 'cOverDeltaT', 'luFL', 'luFU', 'luFP' ) ;
   else
      cOverDeltaT = 2 * cOverDeltaT ;

      B = cOverDeltaT - G ;
      F = cOverDeltaT + G ;

      [ luFL, luFU, luFP ] = lu( F ) ;

      %save( lupCachePath, 'F', 'B', 'luFL', 'luFL', 'luFP' ) ;
   end
%end

%if ( withBE )
%   voltageCachePath = sprintf( 'be.VoltageDeltaTps_%d.mat', deltaT * 1000 ) ;
%else
%   voltageCachePath = sprintf( 'tr.VoltageDeltaTps_%d.mat', deltaT * 1000 ) ;
%end

%if ( exist( voltageCachePath, 'file' ) )
%   load( voltageCachePath ) ;
%else
   %numCpuMeasurementSamples = 3 ;
   numCpuMeasurementSamples = 1 ;
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

      v = ones( 1/deltaT + 1, 1 ) ;
%      v = vclock( discreteTimes ) ;

      if ( withBE )
         i = 1 ;
         for t = discreteTimes(2:end)
            newV = v( i ) ;

            if ( newV ~= vv )
               vv = newV ;
               bv = b * vv ;
            end

            r = luFP * (cOverDeltaT * x + bv) ;
            y = luFL\r ;
            x = luFL\y ;
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

            r = luFP * (B * x + c) ;
            y = luFL\r ;
            x = luFL\y ;
            s( end + 1 ) = L.' * x ;

            i = i + 1 ;
         end
      end
      iterationTimes(end+1) = toc ;
   end

%   save( voltageCachePath, 'discreteTimes', 'v', 's', 'iterationTimes' ) ;
%end
