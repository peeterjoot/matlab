function testH(filename)

   if ( nargin < 1 )
      %filename = '../circuits/diode1.netlist' ;
      %filename = '../circuits/rc.netlist' ;
      %filename = '../circuits/rcVsource.netlist' ;
      %filename = '../circuits/rc2.netlist' ;
      %filename = '../circuits/res2.netlist' ;
      filename = '../circuits/LCLowpass.netlist' ;
   end

   N = 20 ;

   p = struct( 'useStepping', 0 ) ;
   r = NewtonsHarmonicBalance( N, filename, p ) ;

   %full(real(r.B))
   %full(imag(r.B))
   %r.angularVelocities
   %full(r.G)
   %full(r.C)
   %real(r.Y)
   %imag(r.Y)
   %r.I
   %r.Y * r.V - r.I - r.II
   %r.V
   %r.Vnames
   %r.f
   %r.iter
   %r.normF
   %r.normDeltaV
   %r.totalIters

   % sort output into physical parameters

   twoNplusOne = 2 * N + 1 ;
   R = size( r.xnames, 1 ) ;
   v = real( r.v ) ;
   tk = 2 * pi * (-N:N)/ (r.omega * twoNplusOne ) ;

   for i = 1:R
      %disp( r.xnames{i} ) ;
      figure ;
      plot( tk, v( i : R : end ) ) ;
      xlabel( 't' ) ;
      ylabel( r.xnames{i} ) ;
   end

% verify F^{-1} = \bar{F}/(2 N + 1)
%
%   ii = r.Finv * r.F ;
%   (real(ii) - eye( twoNplusOne )) > 1e-10
%   imag(ii) > 1e-10

end
