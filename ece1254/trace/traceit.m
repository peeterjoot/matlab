function traceit(string)
% trace a string
%   if enableTrace() has been called, and disableTrace() has not, then the value of the string will be printed
%   following a 'debug: ' prefix.
%
   global g_bTraceOn ;

   if g_bTraceOn
       [ST,I] = dbstack( 1 ) ;

       fprintf( 'debug: %s:%d: %s\n', ST(1).name, ST(1).line, string ) ;
   end
end
