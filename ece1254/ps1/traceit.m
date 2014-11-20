function traceit(string)
% trace a string
%   if enableTrace() has been called, and disableTrace() has not, then the value of the string will be printed
%   following a 'debug: ' prefix.
%
   global g_bTraceOn ;
   
   if g_bTraceOn
       fprintf( 'debug: %s\n', string ) ;
   end
end
