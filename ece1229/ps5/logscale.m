function r = logscale( a, minDb )
   % LOGSCALE: rescale a(:) in [0,1] value to db scale, with 0 dB at 1, and cutoff of minDb at origin

   %disp( size(a) ) ;
   %disp( size(minDb) ) ;

   cutoff = 10^(minDb/ 10) ;
   scale = -10/minDb ;
   % FIXME: how to vectorize this?  What's a good way to allocate an uninitialized matrix 
   % in matlab (this is an easy way to get one of the right size, but we don't need it to be 
   % zero or anything else since all elements are covered in the loop).
   r = a ;

   for i = 1:length(a)
      if ( a(i) < cutoff )
         r(i) = 0 ;
      else
         r(i) = scale * log10( a(i) ) + 1 ;
      end
   end
end
