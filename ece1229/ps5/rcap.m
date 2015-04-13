function r = rcap(t, p)
   % rcap: spherical polar radial unit vector

   %rcap = @(t,p) [ sin(t) * cos(p) , sin(t) * sin(p) , cos(t) ] ;
   r = [ sin(t) * cos(p) , sin(t) * sin(p) , cos(t) ] ;
end
