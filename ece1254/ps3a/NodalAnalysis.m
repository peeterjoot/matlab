function [G, C, b, xnames] = NodalAnalysis(filename)
% NodalAnalysis generates the modified nodal analysis (MNA) equations from a text file
%
% Based on NodalAnalysis.m from ps2, generalized to add capacitance and inductance support.
% also adds:
%   - comment lines (starting with *) as described in:
%     http://jjc.hydrus.net/jjc/technical/ee/documents/spicehowto.pdf 
%
% This routine [G, C, b, x] = NodalAnalysis(filename)
% generates the modified nodal analysis (MNA) equations
%
%    G x(t) + C \dot{x}(t)= B u(t) = b(t)
%
% Here the column vector u(t) contains all sources, and x(t) is a vector of all the sources.
%
%---------------------------------------------------------------------------------------
%
% Deviations from the problem specification:
%
% The problem specification said to use B u(t) instead of b(t), but there's no
% real need for factoring out a matrix B for the use of this problem, so I've opted for a
% representation that uses less space for now.
%
% Also note that the syntax of the .netlist parser has not been modified to allow non-DC
% sources.  For ps3a, we have only a single source, so we can scale the returned constant
% vector b by whatever time dependent signal we desire.
%
%---------------------------------------------------------------------------------------
%
% The returned value:
%
%   xnames
%
% is an array of strings representing the voltage, voltage source currents,
% voltage controlled voltage source currents, and the inductor currents.
%
% These matrices are generated from a text file (netlist) that describes an
% electrical circuit made of resistors, independent current sources,
% independent voltage sources, voltage-controlled voltage sources, capacitors, and inductors. 
%
% For the netlist, we use the widely-adopted SPICE syntax, as simplified with the following assumptions:
%
%   - .end terminates the netlist
%   - The first line of netlist is a (title) comment unless it starts with R, I, V, E, C, or L.
%   - The netlist file will always include a 0 (ground) node.  There is no error checking to ensure that
%     at least one element is connected to a ground node.
%   - There are no gaps in the node numbers.
%   - I seem to recall that spice files allowed the constants to be specified with k, m, M modifiers.
%     I haven't tried to support that.
%   - trailing comments (; and anything after that) as described in:
%     https://www.csupomona.edu/~prnelson/courses/ece220/220-spice-notes.pdf
%     are not supported.
%
% as a test, compare to results from:
%
%  http://embedded.eecs.berkeley.edu/pubs/downloads/spice/spice3f5.tar.gz
%
% The netlist elements lines are specified as follows:
%
% - For each resistor, the file will contain a line in the form
% 
%     Rlabel node1 node2 value
% 
%   where "value" is the resistance value.
%
% - Current sources are specified with the line
% 
%     Ilabel node1 node2 DC value
% 
%   and current flows from node1 to node2.  Note that DC is just a keyword.
%   Here value, a floating point numbrer, can be interpreted as a constant amplitude for the current,
%   as scaled by a time dependent component of the full source vector u(t).
%
% - A voltage source connected between the nodes node+ and node- is specified by the line
% 
%     Vlabel node+ node- DC value
% 
%   where node+ and node- identify, respectively, the node where the positive
%   and "negative" terminal is connected to, and value is the constant amplitude
%   of the voltage source (a floating point value), which may be scaled by a time dependent
%   component of the full source vector u(t).
%
% - A voltage-controlled voltage source,
%   connected between the nodesnode+ and node-, is specified by the line
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

   %enableTrace() ;
   traceit( ['filename: ', filename] ) ;

   currentLines   = [] ;
   resistorLines  = [] ;
   voltageLines   = [] ;
   currentLines   = [] ;
   ampLines       = [] ;
   capLines       = [] ;
   indLines       = [] ;

   currentLables  = {} ;
   resistorLables = {} ;
   voltageLables  = {} ;
   currentLables  = {} ;
   ampLables      = {} ;
   capLables      = {} ;
   indLables      = {} ;

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
      case 'I'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if sz ~= 5
            error( 'NodalAnalysis:parseline:I', 'expected 5 fields, but read %d fields from current line "%s"', sz, line ) ;
         end
         if ( ~strcmp( 'DC', tmp{4} ) )
            error( 'NodalAnalysis:parseline:I', 'expected DC field in line "%s", found "%s"', line, tmp{4} ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         g = str2double( tmp{5} ) ;
         a = [ n1 n2 g ] ;

         currentLines(:,end+1) = a ;
         currentLables{end+1} = tmp{1} ;
      case 'V'
         firstLineRead = 1 ;
         tmp = strsplit( line ) ;
         sz = size( tmp, 2 ) ;

         if sz ~= 5
            error( 'NodalAnalysis:parseline:V', 'expected 5 fields, but read %d fields from current line "%s"', sz, line ) ;
         end
         if ( ~strcmp( 'DC', tmp{4} ) )
            error( 'NodalAnalysis:parseline:V', 'expected DC field in line "%s", found "%s"', line, tmp{4} ) ;
         end

         n1 = str2num( tmp{2} ) ;
         n2 = str2num( tmp{3} ) ;
         g = str2double( tmp{5} ) ;
         a = [ n1 n2 g ] ;

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
   allnodes = zeros(2, 1) ;

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
   end
   sz = size( voltageLines, 2 ) ;
   if ( sz )
      traceit( sprintf( 'voltageLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, voltageLines(1:2, :) ) ;
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
   %B = zeros( biggestNodeNumber + numAdditionalSources, biggestNodeNumber + numAdditionalSources ) ;
   b = zeros( biggestNodeNumber + numAdditionalSources, 1 ) ;

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
      labelNumber = labelNumber + 1 ;
      label       = voltageLables{labelNumber} ;
      plusNode    = v(1) ;
      minusNode   = v(2) ;
      value       = v(3) ;
  
      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;
      xnames{r} = sprintf( 'i_{%s_{%d,%d}}', label, minusNode, plusNode ) ;

      if ( plusNode )
         G( r, plusNode ) = 1 ;
         G( plusNode, r ) = -1 ;
      end
      if ( minusNode )
         G( r, minusNode ) = -1 ;
         G( minusNode, r ) = 1 ;
      end

      %B( r, r ) = value ;
      b( r, 1 ) = value ;
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
      labelNumber = labelNumber + 1 ;
      label       = currentLables{labelNumber} ;
      plusNode    = i(1) ;
      minusNode   = i(2) ;
      value       = i(3) ;

      traceit( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

      if ( plusNode )
         %B( plusNode, plusNode ) = B( plusNode, plusNode ) - value ;
         b( plusNode, 1 ) = b( plusNode, 1 ) - value ;
      end
      if ( minusNode )
         %B( minusNode, minusNode ) = B( minusNode, minusNode ) + value ;
         b( minusNode, 1 ) = b( minusNode, 1 ) + value ;
      end
   end
end
