clear all ;

format short eng ;

netlistFileName = 'ps1.2.netlist' ;

epsilon = eps( 1.0 ) * 100 ;

doProblemB = 1 ;

if ( doProblemB )
   % p2(b).  Plot times vs. N
   %gridSizes = 2:4:50 ;
   gridSizes = [ 4 8 12 16 20 24 28 32 36 40 44 ] ;
   numTimings = 1 ;
else
   % p2(a)
   gridSizes = [ 50 ] ;
   numTimings = 3 ;
end
numGrids = size( gridSizes, 2 ) ;

luTimings       = zeros( numTimings, numGrids ) ;
forwardTimings  = zeros( numTimings, numGrids ) ;
backwardTimings = zeros( numTimings, numGrids ) ;
solveTimings    = zeros( numTimings, numGrids ) ;

% interval timing:
% http://cens.ioc.ee/local/man/matlab/techdoc/ref/tic.html

for j = 1:numGrids
   generateResistorGridNetlist( netlistFileName, gridSizes(j) ) ;
   [G, b] = NodalAnalysis( netlistFileName ) ;


   for i = 1:numTimings
      tic
      [P, L, U, s] = withPivotLU( G, epsilon ) ;
      luTimings(i, j) = toc ;

      tic
      y = forwardSubst( P * L, P * b, epsilon ) ;
      forwardTimings(i, j) = toc ;

      tic
      x = backSubst( U, y, epsilon ) ;
      backwardTimings(i, j) = toc ;

      tic
      xm = G\b ;
      solveTimings(i, j) = toc ;
   end

   % sanity check: expect something near zero:
   %max(max(abs(G - L * U)))
end

if ( doProblemB )
   totalTimes = luTimings + forwardTimings + backwardTimings ;

   logTotalTimes = log( totalTimes ) ;
   logN = log( gridSizes ) ;

   p = polyfit( logN, logTotalTimes, 1 ) ;
   m = p(1) ;
   a = p(2) ;

   fitCheck = zeros(numGrids, 1) ;
   logFitCheck = zeros(numGrids, 1) ;
   for i = 1:numGrids
      logFitCheck(i) = a + logN( i ) * m ;
      fitCheck(i) = exp(a) * gridSizes(i)^m ;
   end

   m
   exp(a)
   figure ; plot( logN, logFitCheck, logN, logTotalTimes )
   figure ; plot( gridSizes, fitCheck, gridSizes, totalTimes )

%>> blah=[0 1]
%     0.0000e+000     1.0000e+000
%
%>> blahy = [0 2]
%     0.0000e+000     2.0000e+000
%
%>> polyfit( blah, blahy, 1 )
%     2.0000e+000     0.0000e+000

else
   % do the surface plot

   % surf() is a surface plot function, that takes three arrays, one for X coordinate, one for Y coordinates, and one
   % for the value of the function at each of these points.
   %>> [X,Y,Z] = peaks(3); figure ; surf(X,Y,Z)
   %>> X
   %X =
   %    -3.0000e+000     0.0000e+000     3.0000e+000
   %    -3.0000e+000     0.0000e+000     3.0000e+000
   %    -3.0000e+000     0.0000e+000     3.0000e+000
   %
   %>> Y
   %Y =
   %    -3.0000e+000    -3.0000e+000    -3.0000e+000
   %     0.0000e+000     0.0000e+000     0.0000e+000
   %     3.0000e+000     3.0000e+000     3.0000e+000
   %
   %>> Z
   %
   %Z = ...

   n = gridSizes(1) ;
   X = zeros( n ) ;
   Y = zeros( n ) ;
   Z = zeros( n ) ;

   % to map from row,column = i,j to node number we use: n(i,j) = (N+1)(i-1) + j
   for i = 1:n+1
   for j = 1:n+1
      X(i,j) = i ;
      Y(i,j) = j ;
      Z(i,j) = x( (n+1) * (i-1) + j ) ;
   end
   end
   
   figure ;
   surf( X, Y, Z ) ;
end

