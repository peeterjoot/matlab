function v = clk(t)
% Model the clock source with a periodic voltage source with the following characteristics: amplitude 1 V, rise/fall time 100 ps, period 2 ns, duty cycle 50%, initial delay 100 ps.
%
% [in]: scalar t >= 0 [in] (seconds)
% [out]: scalar v (volts)
%

if ( t < 0 )
   error( 'clk:', 'expected time value t (=%e) >= 0', t ) ;
end

ns = 1e-9 ;
t = mod( t / ns, 2 ) ;

% 100ps == 0.1 ns.

% vectorized implementation, using method from: http://stackoverflow.com/a/27097962/189270
% doesn't work?
if ( 0 )
   v = zeros(size(t)) ;

   filt1 = t < 0.1 ;
   filt2 = ~filt1 & (t < 0.2) ;
   filt3 = ~filt2 & (t < 1.1) ;
   filt4 = ~filt3 & (t < 1.2) ;

   % (v - 0)/(t - 0.1) = 1/0.1
   v(filt2) = 10 * t(filt2) - 1 ;

   v(filt3) = 1 ;

   % (v - 0)/(t - 1.2) = 1/(-0.1)
   v(filt4) = 12 - 10 * t(filt4) ;
else
   if ( t < 0.1 )
      v = 0 ;
   elseif ( t < 0.2 )
      % (v - 0)/(t - 0.1) = 1/0.1

      v = 10 * t - 1 ;
   elseif ( t < 1.1 )
      v = 1 ;
   elseif ( t < 1.2 )
      % (v - 0)/(t - 1.2) = 1/(-0.1)

      v = 12 - 10 * t ;
   else
      v = 0 ;
   end
end
