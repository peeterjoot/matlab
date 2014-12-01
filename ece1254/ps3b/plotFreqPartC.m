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
if ( exist(nodalCacheName, 'file' )
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

if ( 0 )
   omega = logspace( -8, 4, n ) ;
   f = PlotFreqResp( omega, G, C, B, L ) ;
   %saveas( f, 'ps3bFreqResponsePartCFig1.png' ) ;
end

stateSpaceCacheName = sprintf('statespace%d_%d_%d.mat', n, where, withOpenCircuitEndpoints ) ;
if ( exist(stateSpaceCacheName, 'file' )
   load( stateSpaceCacheName ) ;
else

   invC = inv(C) ;
   A = -inv(C) * G ;
   [V, D] = sorteig( A ) ;

   b = inv(V) * invC * B ;

   omega = logspace( -8, 4, n ) ;
   PlotFreqResp( omega, G, C, B, L ) ;
      
end 

%Cinv = inv( C ) ;
% how to select from eigenvalues:
%>> [B,I] = sort(abs(diag(D)))
%
%B =
%
%   193.5728e-018
%   147.9757e-003
%   174.0316e-003
%     1.4678e+000
%     6.5262e+000
%
%
%I =
%
%     4.0000e+000
%     3.0000e+000
%     5.0000e+000
%     2.0000e+000
%     1.0000e+000
%
%>> abs(diag(D))
%ans =
%
%     6.5262e+000
%     1.4678e+000
%   147.9757e-003
%   193.5728e-018
%   174.0316e-003

% Cinv * G
%Cinv * B

