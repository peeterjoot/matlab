function g_bDebugOn = isDebugEnabled( )
% check if debug mode is enabled.  If neither enableDebug() nor disableDebug() has been called, this 
% disable debug modes.
   global g_bDebugOn ;

   if ( size(g_bDebugOn, 1) == 0 )
      g_bDebugOn = 0 ;
   end
end
