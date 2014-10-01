function disableTrace( )
% disable debug tracing.
%    Sets a global trace variable to zero so that calls to trace( ... ) don't print anything.
%
   changeTrace( 0 ) ;
end
