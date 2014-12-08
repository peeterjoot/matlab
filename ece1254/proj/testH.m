function testH(filename)

   if ( nargin < 1 )
      filename = 'tests/diode1.netlist' ;
   end

   N = 1 ;
   tol = 1e-6 ;
   tolF = 1e-6 ;
   tolV = 1e-6 ;
   tolRel = 1e-6 ;
   maxIter = 50 ;
   useStepping = 0 ;

   [V, Vnames, F, Fbar, f, iter, normF, normDeltaV, totalIters] = NewtonsHarmonicBalance( filename, N, tolF, tolV, tolRel, maxIter, useStepping ) ;

   V
   Vnames
   f
   iter
   normF
   normDeltaV
   totalIters

%   for 
%   Vp = 

end   
