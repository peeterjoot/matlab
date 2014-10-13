function plotHeatQ1(n)
% plot the netlist results for ps1 p3b
%
% For details see the ps1 pdf.
%
   filename = 'heat1a.netlist' ;
   
   generateHeatNetlist( filename, n ) ;
   
   [G, b] = NodalAnalysis( filename ) ;

%   disp(G) ;   
%   disp(b) ;   
   x = G\b ;
   t = x( 1:n ) ;
   
   deltaX = 1/(n-1) ;
   
   xi = 0:deltaX:1 ;
   
   plot( xi, t ) ;
end
