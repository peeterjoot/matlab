function plotHeatQ(n, doProblemA, withSine)
% plot the netlist results for ps1 p3b, and p3d.
%
% For details see the ps1 pdf.
%
   filename = 'heat.netlist' ;
   
   generateHeatNetlist( filename, n, doProblemA, withSine ) ;
   
   [G, b] = NodalAnalysis( filename ) ;

%   disp(G) ;   
%   disp(b) ;   
   x = G\b ;
   t = x( 1:n ) ;
   
   deltaX = 1/(n-1) ;
   
   xi = 0:deltaX:1 ;

disp('min, max:') ;
min(t)
max(t)

%figure;
   plot( xi, t ) ;
end
