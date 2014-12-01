function plotFreqPartC( n, where, withOpenCircuitEndpoints )
% pass 500,1,0 to use PlotFreqResp to plot N=500 case 1, for part (c).
% pass 500,1,1 to use PlotFreqResp to plot N=500 case 1, for part (d).
%
% parameters:
% n [integer] : number of discretization intervals to use (500 for the problem)
% where [integer] : the component of the frequency response of interest (1 for this case, looking at the response
%                   for the heat at the left end of the bar).
% withOpenCircuitEndpoints [boolean]: 0 to use a zero voltage source to model the zero heat flow at the end points boundary value constraint.  1 to use a big resistor and small capacitor pair in parallel dangling from the end points into ``space''.

L = zeros( n + 3, 1 ) ;
L(where) = 1 ;
if ( (where > (n+3)) || (where < 1) )
   error( 'plotFreqPartC:where', 'value for where (%d) not in range', where ) ;
end

nodalCacheName = sprintf('nodal%d_%d_%d.mat', n, where, withOpenCircuitEndpoints ) ;
if ( exist( nodalCacheName, 'file' ) )
   load( nodalCacheName ) ;
else
   alpha = 0.01 ;
   netlist = 'a.netlist' ;

   generateNetlist( netlist, n, alpha, 1 ) ;

   [G, C, B, xnames] = NodalAnalysis( netlist, 1 ) ;

   if ( n <= 10 )
   %   traceit( sprintf('G, C, B\n%s\n%s\n%s\n', mat2str( G ), mat2str( C ), mat2str( B ) ) ) ;
      disp( G ) ;
      disp( C ) ;
      disp( B ) ;
      disp( xnames ) ;
   end

   save( nodalCacheName, 'G', 'C', 'B', 'xnames' ) ;
end

omega = logspace( -8, 4, n ) ;
fullResp = computeFreqResp( omega, G, C, B, L ) ;

if ( 0 )
   f = figure ;
   semilogx( omega, real(fullResp), 'b' ) ;
   xlabel( '\omega' ) ;
   hold on ;
   semilogx( omega, imag(fullResp), 'r' ) ;
   legend( {'Real', 'Imag'} ) ;
   hold off ;

   saveas( f, 'ps3bFreqResponsePartCFig1.png' ) ;
end

if ( 1 )
%   p = [] ;

   stateSpaceCacheName = sprintf('statespace%d_%d_%d.mat', n, where, withOpenCircuitEndpoints ) ;
   if ( exist( stateSpaceCacheName, 'file' ) )
      load( stateSpaceCacheName ) ;
   else

      q = [1 2 4 10 50] ;
%      q = [10] ;
%      q = [1] ;
%      q = [50] ;

      invC = inv(C) ;
      A = -inv(C) * G ;
      [V, D] = sorteig( A, 'descend' ) ;
      
      u = ones( size(B, 1), 1 ) ;
      b = inv(V) * invC * B * u ;
      % w' = D w + b
      % y = L^T V w = (V^T L)^T w

if ( 0 ) 
   f = figure ;
   semilogx( 1:size(D, 1), log10( -diag(D) ), '-.ob' ) ;
   ylabel( 'log_{10}(-\lambda_i)' ) ;
   xlabel( 'i' ) ;
   saveas( f, 'ps3bEigenvaluesFig1.png' ) ;

   diag(D)
end

      ii = 0 ;
      for qq = q
         ii = ii + 1 ;
         ee = diag( D ) ;
         ee = ee( [1:qq] ) ;
         GG = -diag( ee ) ;
if ( 1 )
         bb = b( [1:qq] ) ;
         BB = diag( bb ) ;

         ll = V.' * L ;
         LL = ll( [1:qq] ) ;

         f = figure ;
         response = computeFreqResp( omega, GG, eye( size(GG) ), BB, LL ) ;
%fullResp
%response 

         semilogx( omega, real(fullResp), omega, real(response), omega, imag(fullResp), omega, imag(response) ) ;
         legend( { 'Real (full)',
                   sprintf('Real (q = %d)', qq),
                   'Imag (full)',
                   sprintf('Imag (q = %d)', qq) 
               } ) ;
         xlabel( '\omega' ) ;
         saveas( f, sprintf('ps3bFreqResponsePartCq%dFig%d.png', qq, ii ) ) ;
end
      end
   end 
end 
