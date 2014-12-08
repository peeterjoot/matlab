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

   r = NewtonsHarmonicBalance( filename, N, tolF, tolV, tolRel, maxIter, useStepping ) ;

   r.V
   r.f
   r.iter
   r.normF
   r.normDeltaV
   r.totalIters

% convert to time domain:
%   for 
%   Vp = 

end   
