function [p, f, labels] = plotSolutionIterations( deltaTinNanoseconds, withFigure )

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

p = [] ;
labels = {} ;

if ( withFigure )
   f = figure ;
   hold on ;
else
   f = 0 ;
end

discreteTimes = [0:deltaTinSeconds:5e-9] ;

v = vclock(0) ;
bv = b * v ;

s = [] ;

lupCachePath = sprintf( 'be.deltaTps_%d.mat', deltaTinNanoseconds * 1000 ) ;

if ( exist( lupCachePath, 'file' ) )
   load( lupCachePath ) ;
else
   cOverDeltaT = C/ deltaTinSeconds ;
   A = G + cOverDeltaT ;

   % prep for solving A\r
   [ L, U, P ] = lu( A ) ;

   save( lupCachePath, 'A', 'cOverDeltaT', 'L', 'U', 'P' ) ;
end

x = zeros( size(b) ) ;

% for the plot, only the voltages at the chip load node have to be saved
e = endpoints( 1 ) ;
s(end+1) = x( e ) ;

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

if ( withFigure )
   data = timeseries( vclk, discreteTimes ) ;
   p( end + 1 ) = plot( data ) ;
   labels = { 'v_{chip}' } ;
end

data = timeseries( s, discreteTimes ) ;
p( end + 1 ) = plot( data ) ;
thisLabel = sprintf( 'v_{clk} (\\Delta t = %d ps)', 1000 * deltaTinNanoseconds ) ;

labels{ end + 1 } = thisLabel ;
