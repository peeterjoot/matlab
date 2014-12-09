function testH(filename)

   if ( nargin < 1 )
      %filename = '../circuits/diode1.netlist' ;
      %filename = '../circuits/rc.netlist' ;
      %filename = '../circuits/rcVsource.netlist' ;
      %filename = '../circuits/rc2.netlist' ;
      filename = '../circuits/res2.netlist' ;
   end

   N = 20 ;
   tol = 1e-6 ;
   tolF = 1e-6 ;
   tolV = 1e-6 ;
   tolRel = 1e-6 ;
   maxIter = 50 ;
   useStepping = 0 ;

   [r, xnames, Vnames] = NewtonsHarmonicBalance( filename, N, tolF, tolV, tolRel, maxIter, useStepping ) ;

   %full(real(r.B))
   %full(imag(r.B))
   %r.angularVelocities
   full(r.G)
   %full(r.C)
   %real(r.Y)
   %imag(r.Y)
   r.I
   %r.Y * r.V - r.I - r.II
   %r.V
   %Vnames
   %r.f
   %r.iter
   %r.normF
   %r.normDeltaV
   %r.totalIters

   % sort output into physical parameters

   twoNplusOne = 2 * N + 1 ;
   R = size( xnames, 1 ) ;
   V = zeros( twoNplusOne, R ) ;
   v = zeros( twoNplusOne, R ) ;
   tk = 2 * pi * (-N:N)/ (r.omega * twoNplusOne ) ;

   for i = 1:R
      X = r.V( i : R : end ) ;
      V( :, i ) = X ;
      x = real( r.Finv * X ) ;
      v( :, i ) = x ;

      disp( xnames{i} ) ;
      figure ;
      plot( tk, v( :, i ) ) ;
      xlabel( 't' ) ;
      ylabel( xnames{i} ) ;
   end

% verify F^{-1} = \bar{F}/(2 N + 1)
%
%   ii = r.Finv * r.F ;
%   (real(ii) - eye( twoNplusOne )) > 1e-10
%   imag(ii) > 1e-10

end   
