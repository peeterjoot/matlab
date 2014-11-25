function driver( )

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

if ( 1 )
   % discretization is visible in the plot:

   %deltaT = [0.05] * 1e-9 ;
   %deltaT = [0.01] * 1e-9 ;
   deltaT = [0.005 ] * 1e-9 ;
   %deltaT = [0.001 ] * 1e-9 ;

   savepath = '../../../figures/ece1254/ps3aBEFig1.png' ;   
else

   % This was an attempt to generate a set of plots with different timesteps, all superimposed, but 
   % doesn't work.  Some kind of state gets cached and messes up after subsequent plots.
   % I mistakenly thought that the plot mess resulting was due to different time scales and used the
   % timeseries() function as an attempt to work around this.  That didn't help.
   %
   % In the end the ps3aBEFig2.png plot was generated manually by hacking this function temporarily, retaining hold on
   % and calling it multiple times, manually adding in the legend() afterwards.
   %
   deltaT = [0.1 0.05 0.01 0.005] * 1e-9 ;

   savepath = '../../../figures/ece1254/ps3aBEFig2.png' ;   
end

p = [] ;
labels = {} ;
i = 0 ;

hold off ;
f = figure ;
hold on ;

for tt = deltaT
   discreteTimes = [0:deltaT:5e-9] ;

   v = vclock(0) ;
   bv = b * v ;

   s = [] ;

   cOverDeltaT = C/ tt ;
   A = G + cOverDeltaT ;
   x = zeros( size(b) ) ;

   % for the plot, only the voltages at the chip load node have to be saved
   e = endpoints( 1 ) ;
   s(end+1) = x( e ) ;

   % prep for solving A\r
   [ L, U, P ] = lu( A ) ;

   vclk = [ 0 ] ;

   for t = discreteTimes(2:end)
      newV = vclock( t ) ;
      vclk(:, end+1) = newV ;

      if ( newV ~= v )
         v = newV ;
         bv = b * v ;
      end

      r = P * (cOverDeltaT * x + bv) ;
      y = L\r ;
      x = U\y ;
      s(end+1) = x(e) ;
   end

   if ( (i == 0) && 1 )
      data = timeseries( vclk, discreteTimes ) ;
      p( end + 1 ) = plot( data ) ;
      labels = { 'v_{chip}' } ;
   end

   data = timeseries( s, discreteTimes ) ;
   p( end + 1 ) = plot( data ) ;
   thisLabel = sprintf( 'v_{clk} (\\Delta t = %d ps)', round(tt/ 1e-12) ) ;

   labels{ end + 1 } = thisLabel ;

   i = i + 1 ;
end

xlabel( 'time (s)' ) ;
ylabel( 'Voltage (V)' ) ;
legend( labels ) ;
hold off ;

if ( ~exist( savepath, 'file' ) )
   saveas( f, savepath ) ;
end
