function r = thetacap(t, p)
   % thetacap: spherical polar theta unit vector

   %thetacap = @(t,p) [ cos(t) * cos(p) , cos(t) * sin(p) , -sin(t) ] ;
   r = [ cos(t) * cos(p) , cos(t) * sin(p) , -sin(t) ] ;
end
