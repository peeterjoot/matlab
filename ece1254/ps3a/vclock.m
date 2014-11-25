function v = vclock(t)
% Model the clock source with a periodic voltage source with the following characteristics: amplitude 1 V, rise/fall time 100 ps, period 2 ns, duty cycle 50%, initial delay 100 ps.
%
% [in]: scalar t >= 0 [in] (seconds)
% [out]: scalar v (volts) 
%

if ( t < 0 )
   error( 'vclock:', 'error opening file "%s"', filename ) ;
end

ns = 1e-9 ;
t = mod( t / ns, 2 ) ;

% 100ps == 0.1 ns.
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
