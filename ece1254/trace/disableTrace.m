function disableTrace( )
% disable debug tracing.
%    Sets a global trace variable to zero so that calls to traceit( ... ) don't print anything.
%
   changeTrace( 0 ) ;
end
