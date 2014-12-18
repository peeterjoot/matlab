Generic Problem Determination (PD) methods.

changeTrace( v )
   enable or disable trace

disableTrace( )
   disable debug tracing.
   Sets a global trace variable to zero so that calls to traceit( ... ) don't print anything.

enableTrace( )
   enable debug tracing.
   Sets a global trace variable to non-zero so that calls to traceit( ... ) don't print anything.

traceit(string)
   trace a string

   if enableTrace() has been called, and disableTrace() has not, then the value of the string will be printed
   following a 'debug: ' prefix.

isDebugEnabled( )
   check if debug mode is enabled.  If neither enableDebug() nor disableDebug() has been called, this
   disable debug modes.

enableDebug( )
   enable debug mode.
   Sets a global debug variable to non-zero so that calls to verify( ... ) don't print anything.

