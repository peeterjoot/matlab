function [G, C, B, bdiode, u, xnames] = NodalAnalysis(filename)
% NodalAnalysis generates the modified nodal analysis (MNA) equations from a text file
%
% This is based on NodalAnalysis.m from ps3a (which included RLC support), and has been generalized to add support
% for non-DC sources and diodes.
%
% This routine [G, C, B, u, x] = NodalAnalysis(filename)
% generates the modified nodal analysis (MNA) equations
%
%    G x(t) + C \dot{x}(t)= B u(t)
%
% Here the column vector u(t) contains all sources, and x(t) is a vector of all the sources.
% 
%---------------------------------------------------------------------------------------
%
% NETLIST SYNTAX:
%
% These matrices are generated from a text file (netlist) that describes an
% electrical circuit made of resistors, independent current sources,
% independent voltage sources, voltage-controlled voltage sources, capacitors, and inductors. 
%
% For the netlist, we use the widely-adopted SPICE syntax, as simplified with the following assumptions:
%
%   - .end terminates the netlist.  This is case sensitive (unlike spice)
%   - The first line of netlist is a (title) comment unless it starts with R, I, V, E, C, or L.
%   - The netlist file will always include a 0 (ground) node.  There is no error checking to ensure that
%     at least one element is connected to a ground node.
%   - There are no gaps in the node numbers.
%   - I seem to recall that spice files allowed the constants to be specified with k, m, M modifiers.
%     I haven't tried to support that.
%   - Trailing comments (; and anything after that) as described in:
%     https://www.csupomona.edu/~prnelson/courses/ece220/220-spice-notes.pdf
%     are not supported.
%
% The netlist elements lines are specified as follows:
%
% - The syntax for specifying a resistor is a line of the form:
% 
%     Rlabel node1 node2 value
% 
%   where "value" is the resistance value.
%
% - The syntax for specifying a current source is lines of the form:
% 
%     Ilabel node1 node2 DC value
%     Ilabel node1 node2 AC value freq [phase]
% 
%   and current flows from node1 to node2.
%   Here value, a floating point number, is the amplitude of the current.
%   A line with 'DC value' is equivalent to that of 'AC value 0'. The parameter
%   freq is the frequency in Hertz of the input signal.
%
% - The syntax for specifying a voltage source connected between the nodes node+ and
%   node- is one of:
% 
%     Vlabel node+ node- DC value
%     Vlabel node+ node- AC value freq [phase]
% 
%   where node+ and node- identify, respectively, the node where the positive
%   and "negative" terminal is connected to, and value is the amplitude
%   of the voltage source (a floating point value).
%   A line with 'DC value' is equivalent to that of 'AC value 0'. The parameter
%   freq is the frequency in Hertz of the input signal.
%
% - The syntax for specifying a voltage-controlled voltage source,
%   connected between the nodesnode+ and node-, is:
% 
%     Elabel node+ node- nodectrl+ nodectrl- gain
% 
%   The controlling voltage is between the nodes nodectrl+ and nodectrl-,
%   and the last argument is the source gain (a floating point number).
% 
% - The syntax for specifying a capacitor is:
% 
%     Clabel node1 node2 val
%
%   where label is an arbitrary label, node1 and node2 are integer circuit node numbers, and val is
%   the capacitance (a floating point number).
%
% - The syntax for specifying an inductor is:
% 
%     Llabel node1 node2 val
% 
%   where label is an arbitrary label, node1 and node2 are integer circuit node numbers, and val
%   is the inductance (a floating point number).
% 
% - The syntax for specifying a diode modelled by I_d = I_0 ( e^{V/V_t} - 1 ) is:
%
%     Dlabel node1 node2 I_0 V_T
%
%   where V = V_n1 - V_n2, and the current flows from n1 to n2.
%    
% - Comment lines, starting with *, as described in the following, are allowed:
%     http://jjc.hydrus.net/jjc/technical/ee/documents/spicehowto.pdf 
%
%------------------------------------------------
%
% INPUT PARAMETERS:
%
% - filename [string]:
%
%     netlist source file to read.
%
%------------------------------------------------
%
% OUTPUT VARIABLES:
%
% With N equal to the total number of MNA variables, the returned parameters are
% 
% - G [array]
% 
%    NxN matrix of resistance stamps.
% 
% - C [array]   
% 
%    NxN matrix of stamps for the time dependent portion of the MNA equations.
% 
% - B [array]
% 
%    NxM matrix of constant source terms.  Each column encodes the current sources 
%    for increasing frequencies.  For example, if there are DC sources in 
%    the circuit the first column would have contributions from the DC sources, 
%    and any columns after that would be for higher frequencies.
% 
% - u [array]
%   
%    Mx1 matrix of frequencies, ordered from lowest to highest.  
%    A zero value (in the 1,1 position) represents a DC source.
% 
% - xnames [cell]
% 
%   is an Nx1 array of strings for each of the variables in the resulting system.  
%   Entries will be added to this for each node voltage in the system.  
%   Current variables will be added for each DC voltage source, each DC voltage
%   controlled voltage source, as well as any inductor currents.
% 
%------------------------------------------------

   %enableTrace() ;
   traceit( ['filename: ', filename] ) ;

   currentLines   = [] ;
   resistorLines  = [] ;
   voltageLines   = [] ;
   ampLines       = [] ;
   capLines       = [] ;
   indLines       = [] ;
   diodeLines     = [] ;

   currentLables  = {} ;
   resistorLables = {} ;
   voltageLables  = {} ;
   ampLables      = {} ;
   capLables      = {} ;
   indLables      = {} ;
   diodeLables    = {} ;

   %----------------------------------------------------------------------------
   %
   % Parse the netlist file.  Collect up the results into some temporary arrays so we can figure out the max node number
   % and other info along the way.
   %
   fh = fopen( filename ) ;
   if ( -1 == fh )
      error( 'NodalAnalysis:fopen', 'error opening file "%s"', filename ) ;
   end

   firstLineRead = 0 ;

   while ~feof( fh )
      line = fgetl( fh ) ;

      traceit( ['line: ', line] ) ;

      switch line(1:1)
      case 'R'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:R', 'expected 4 fields, but read %d fields from resistor line "%s"', sz, line ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         v = str2double( tmp{4} ) ;
         a = [ n1 n2 v ] ;

         resistorLines(:,end+1) = a ;
         resistorLables{end+1} = tmp{1} ;
      case 'C'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:C', 'expected 4 fields, but read %d fields from capacitor line "%s"', sz, line ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         v = str2double( tmp{4} ) ;
         a = [ n1 n2 v ] ;

         capLines(:,end+1) = a ;
         capLables{end+1} = tmp{1} ;
      case 'L'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:L', 'expected 4 fields, but read %d fields from inductor line "%s"', sz, line ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         v = str2double( tmp{4} ) ;
         a = [ n1 n2 v ] ;

         indLines(:,end+1) = a ;
         indLables{end+1} = tmp{1} ;
      case 'E'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( sz ~= 6 )
            error( 'NodalAnalysis:parseline:E', 'expected 6 fields, but read %d fields from controlling voltage line "%s"', sz, line ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         nc1 = str2num( tmp{4} ) ;
         nc2 = str2num( tmp{5} ) ;
         g = str2double( tmp{6} ) ;
         a = [ n1 n2 nc1 nc2 g ] ;

         ampLines(:,end+1) = a ;
         ampLables{end+1} = tmp{1} ;
      case 'D'
         % Dlabel node1 node2 I_0 V_T

         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( sz ~= 5 )
            error( 'NodalAnalysis:parseline:D', 'expected 5 fields, but read %d fields from diode line "%s"', sz, line ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         io = str2num( tmp{4} ) ;
         vt = str2num( tmp{5} ) ;
         a = [ n1 n2 io vt ] ;

         diodeLines(:,end+1) = a ;
         diodeLables{end+1} = tmp{1} ;
      case 'I'
         % Ilabel node1 node2 DC value
         % Ilabel node1 node2 AC value freq [phase]

         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( (sz < 5) || (sz > 7) )
            error( 'NodalAnalysis:parseline:I', 'expected 5-7 fields, but read %d fields from current line "%s"', sz, line ) ;
         end
         if ( sz == 5 )
            if ( ~strcmp( 'DC', tmp{4} ) )
               error( 'NodalAnalysis:parseline:I', 'expected DC field in line "%s", found "%s"', line, tmp{4} ) ;
            end
         else
            if ( ~strcmp( 'AC', tmp{4} ) )
               error( 'NodalAnalysis:parseline:I', 'expected AC field in line "%s", found "%s"', line, tmp{4} ) ;
            end
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         g = str2double( tmp{5} ) ;
         if ( sz > 5 )
            freq = str2num( tmp{6} ) ;
         else
            freq = 0 ;
         end
         if ( sz > 6 )
            phase = str2num( tmp{7} ) ;
         else
            phase = 0 ;
         end
         a = [ n1 n2 g freq phase ] ;

         currentLines(:,end+1) = a ;
         currentLables{end+1} = tmp{1} ;
      case 'V'
         % Vlabel node1 node2 DC value
         % Vlabel node1 node2 AC value freq [phase]
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if ( (sz < 5) || (sz > 7) )
            error( 'NodalAnalysis:parseline:V', 'expected 5-7 fields, but read %d fields from current line "%s"', sz, line ) ;
         end
         if ( sz == 5 )
            if ( ~strcmp( 'DC', tmp{4} ) )
               error( 'NodalAnalysis:parseline:V', 'expected DC field in line "%s", found "%s"', line, tmp{4} ) ;
            end
         else
            if ( ~strcmp( 'AC', tmp{4} ) )
               error( 'NodalAnalysis:parseline:V', 'expected AC field in line "%s", found "%s"', line, tmp{4} ) ;
            end
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         g = str2double( tmp{5} ) ;
         if ( sz > 5 )
            freq = str2num( tmp{6} ) ;
         else
            freq = 0 ;
         end
         if ( sz > 6 )
            phase = str2num( tmp{7} ) ;
         else
            phase = 0 ;
         end
         a = [ n1 n2 g freq phase ] ;

         voltageLines(:,end+1) = a ;
         voltageLables{end+1} = tmp{1} ;
      case '*'
         traceit( ['comment line: ', line ] ) ;
      case '.'
         if ( 0 == strncmp( line, '.end', 4 ) )
            error( 'NodalAnalysis:parseline', 'unexpected line "%s"', line ) ;
         else
            break ;
         end
      otherwise
         if ( firstLineRead )
            error( 'NodalAnalysis:parseline', 'expect line "%s" to start with one of R,E,I,V', line ) ;
         end
      end
   end

   fclose( fh ) ;

   % if we wanted to allow for gaps in the node numbers (like 1, 3, 4, 5), then we'd have to count the number of unique node numbers
   % instead of just taking a max, and map the matrix positions to the original node numbers later.
   % 
   allnodes = zeros(2, 1) ; % assume a zero node.
   allfrequencies = zeros(1, 0) ; % don't assume a DC source

%enableTrace() ;
   sz = size( resistorLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'resistorLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, resistorLines(1:2, :) ) ;
   end
   sz = size( currentLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'currentLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, currentLines(1:2, :) ) ;
      allfrequencies = horzcat( allfrequencies, currentLines(4, :) ) ;
   end
   sz = size( diodeLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'diodeLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, diodeLines(1:2, :) ) ;
      allfrequencies = horzcat( allfrequencies, 0 ) ;
   end
   sz = size( voltageLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'voltageLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, voltageLines(1:2, :) ) ;
      allfrequencies = horzcat( allfrequencies, voltageLines(4, :) ) ;
   end
   sz = size( ampLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'ampLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, ampLines(1:2, :), ampLines(3:4, :) ) ;
   end
   sz = size( capLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'capLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, capLines(1:2, :) ) ;
   end
   sz = size( indLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'indLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, indLines(1:2, :) ) ;
   end
%disableTrace() ;

   u = unique( allfrequencies ) ; % note: unique sorts by default
   u = u.' ; % convert to Mx1

   biggestNodeNumber = max( max( allnodes ) ) ;
   traceit( [ 'maxnode: ', sprintf('%d', biggestNodeNumber) ] ) ;

   %
   % Done parsing the netlist file.
   % 
   %----------------------------------------------------------------------------

   numVoltageSources = size( voltageLines, 2 ) ;
   numAmpSources = size( ampLines, 2 ) ;
   numIndSources = size( indLines, 2 ) ;

   numAdditionalSources = numVoltageSources + numAmpSources + numIndSources ;

   % have to adjust these sizes for sources, and voltage control sources
   G = zeros( biggestNodeNumber + numAdditionalSources, biggestNodeNumber + numAdditionalSources ) ;
   C = zeros( biggestNodeNumber + numAdditionalSources, biggestNodeNumber + numAdditionalSources ) ;

   numFrequencies = size( allfrequencies, 2 ) ;

   B = zeros( biggestNodeNumber + numAdditionalSources, numFrequencies ) ;

   xnames = cell( biggestNodeNumber + numAdditionalSources, 1 ) ;
   for i = [1:biggestNodeNumber]
      xnames{i} = sprintf( 'V_%d', i ) ;
   end

   % process the resistor lines:
   % note: matlab for loop appears to iterate over matrix by assigning each column to a temp variable
   labelNumber = 0 ;
   for r = resistorLines
      labelNumber = labelNumber + 1 ;
      label     = resistorLables{labelNumber} ;
      plusNode  = r(1) ;
      minusNode = r(2) ;
      z         = 1/r(3) ;

      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, 1/z ) ) ;

      % insert the stamp:
      if ( plusNode )
         G( plusNode, plusNode ) = G( plusNode, plusNode ) + z ;
         if ( minusNode )
            G( plusNode, minusNode ) = G( plusNode, minusNode ) - z ;
            G( minusNode, plusNode ) = G( minusNode, plusNode ) - z ;
         end
      end
      if ( minusNode )
         G( minusNode, minusNode ) = G( minusNode, minusNode ) + z ;
      end
   end

   % process the capacitor lines:
   labelNumber = 0 ;
   for c = capLines
      labelNumber = labelNumber + 1 ;
      label     = capLables{labelNumber} ;
      plusNode  = c(1) ;
      minusNode = c(2) ;
      cv        = c(3) ;

      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, cv ) ) ;

      % insert the stamp:
      if ( plusNode )
         C( plusNode, plusNode ) = C( plusNode, plusNode ) + cv ;
         if ( minusNode )
            C( plusNode, minusNode ) = C( plusNode, minusNode ) - cv ;
            C( minusNode, plusNode ) = C( minusNode, plusNode ) - cv ;
         end
      end
      if ( minusNode )
         C( minusNode, minusNode ) = C( minusNode, minusNode ) + cv ;
      end
   end

   % process the voltage sources:
   r = biggestNodeNumber ;
   labelNumber = 0 ;
   for v = voltageLines
      r = r + 1 ;
      labelNumber     = labelNumber + 1 ;
      label           = voltageLables{labelNumber} ;
      plusNode        = v(1) ;
      minusNode       = v(2) ;
      value           = v(3) ;
      freq            = v(4) ;
      phase           = v(5) ;
      valueWithPhase  = value * exp( j * phase ) ;
      
      traceit( sprintf( '%s %d,%d -> %d (%e, %e)\n', label, plusNode, minusNode, value, freq, phase ) ) ;
      xnames{r} = sprintf( 'i_{%s_{%d,%d}}', label, minusNode, plusNode ) ;

      if ( plusNode )
         G( r, plusNode ) = 1 ;
         G( plusNode, r ) = -1 ;
      end
      if ( minusNode )
         G( r, minusNode ) = -1 ;
         G( minusNode, r ) = 1 ;
      end

      freqIndex = find( u == freq ) ;
      B( r, freqIndex ) = valueWithPhase ;
   end

   % value for r (fall through from loop above)
   % process the voltage controlled lines
   labelNumber = 0 ;
   for a = ampLines
      r = r + 1 ;
      labelNumber = labelNumber + 1 ;

      label                = ampLables{labelNumber} ;
      plusNodeNum          = a(1) ;
      minusNodeNum         = a(2) ;
      plusControlNodeNum   = a(3) ;
      minusControlNodeNum  = a(4) ;
      gain                 = a(5) ;

      traceit( sprintf( '%s %d,%d (%d,%d) -> %d\n', label, plusNodeNum, minusNodeNum, plusControlNodeNum, minusControlNodeNum, gain ) ) ;

      if ( minusNodeNum )
         G( r, minusNodeNum ) = 1 ;
         G( minusNodeNum, r ) = -1 ;
      end
      if ( plusNodeNum )
         G( r, plusNodeNum ) = -1 ;
         G( plusNodeNum, r ) = 1 ;
      end
      if ( plusControlNodeNum )
         G( r, plusControlNodeNum ) = gain ;
      end
      if ( minusControlNodeNum )
         G( r, minusControlNodeNum ) = -gain ;
      end

      xnames{r} = sprintf( 'i_{%s_{%d,%d}}', label, plusNodeNum, minusNodeNum ) ;
   end

   % value for r (fall through from loop above)
   % process the inductors:
   labelNumber = 0 ;
   for i = indLines
      r = r + 1 ;
      labelNumber = labelNumber + 1 ;
      label       = indLables{labelNumber} ;
      plusNode    = i(1) ;
      minusNode   = i(2) ;
      value       = i(3) ;
  
      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

      if ( plusNode )
         G( r, plusNode ) = -1 ;
         G( plusNode, r ) = 1 ;
      end
      if ( minusNode )
         G( r, minusNode ) = 1 ;
         G( minusNode, r ) = -1 ;
      end

      C( r, r ) = value ;

      xnames{r} = sprintf( 'i_{%s_{%d,%d}}', label, plusNode, minusNode ) ;
   end

   % process the current sources:
   labelNumber = 0 ;
   for i = currentLines
      labelNumber     = labelNumber + 1 ;
      label           = currentLables{labelNumber} ;
      plusNode        = i(1) ;
      minusNode       = i(2) ;
      value           = i(3) ;
      freq            = v(4) ;
      phase           = v(5) ;
      valueWithPhase  = value * exp( j * phase ) ;

      traceit( sprintf( '%s %d,%d -> %d (%e, %e)\n', label, plusNode, minusNode, value, freq, phase ) ) ;

      freqIndex = find( u == freq ) ;
      if ( plusNode )
         B( plusNode, freqIndex ) = B( plusNode, freqIndex ) - valueWithPhase ;
      end
      if ( minusNode )
         B( minusNode, freqIndex ) = B( minusNode, freqIndex ) + valueWithPhase ;
      end
   end
    
   % process the diode sources:
   labelNumber = 0 ;
   d = 0;

   %bdiode = cell( size(B, 1), 1 );
   bdiode = cell( size(diodeLines,2),1 );

   for i = diodeLines
      labelNumber = labelNumber + 1 ;
      label       = diodeLables{labelNumber} ;
      plusNode    = i(1) ;
      minusNode   = i(2) ;
      io          = i(3) ;
      vt          = i(4) ;
      d = d + 1;

      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, -io ) ) ;

      freqIndex = find( u == 0 ) ; % expect this to be zero.
      
      bdiode{d} = struct( 'io', -io, 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
      if ( plusNode )
         B( plusNode, freqIndex ) = B( plusNode, freqIndex ) + io ;

         %bdiode{ plusNode }{end+1} = struct( 'io', -io, 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
      end
      if ( minusNode )
         B( minusNode, freqIndex ) = B( minusNode, freqIndex ) - io ;
         %bdiode{ minusNode }{end+1} = struct( 'io', io, 'vt', vt, 'vp', plusNode, 'vn', minusNode ) ;
      end
   end
end
