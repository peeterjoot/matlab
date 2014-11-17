% Based on NodalAnalysis.m from ps2, generalized to add capacitance and inductance support.
%
% Assumptions (many of which would be probably be invalid for more general spice netlist files).
%
% 1) .end terminates the netlist
% 2) The first line of netlist is a (title) comment unless it starts with R, I, V, E.
% 3) The netlist file will always include a 0 (ground) node.  I haven't tried to check that.
% 4) There are no gaps in the node numbers.
% 5) I seem to recall that spice files allowed the constants to be specified with k, m, M modifiers.
%    I haven't tried to support that.
%

function [G,C,b] = NodalAnalysis(filename)
% NodalAnalysis generates the modified nodal analysis (MNA) equations from a text file
%
% Write a MATLAB routine [G,b]=NodalAnalysis(filename)
% that generates the modified nodal analysis (MNA) equations
% Gx = b (1)
% 
% from a text file (netlist) that describes an electrical circuit made of resis-
% tors, independent current sources, independent voltage sources, voltage-
% controlled voltage sources. For the netlist, we use the widely-adopted
% SPICE syntax. For each resistor, the file will contain a line in the form
% 
% Rlabel node1 node2 value
% 
% where "value" is the resistance value. Current sources are specified with
% the line
% 
% Ilabel node1 node2 DC value
% 
% and current flows from node1 to node2. Note that DC is just a keyword.
% A voltage source connected between the nodes node+ and node- is spec-
% ified by the line
% 
% Vlabel node+ node- DC value
% 
% where node+ and node- identify, respectively, the node where the posi-
% tive and "negative" terminal is connected to. A voltage-controlled volt-
% age source, connected between the nodesnode+ and node-, is specified
% by the line
% 
% Elabel node+ node- nodectrl+ nodectrl- gain
% 
% The controlling voltage is between the nodes nodectrl+ and nodectrl-,
% and the last argument is the source gain.
% 
% --------------------
% ps3a
% --------------------
%
% Modify the circuit simulator you developed for the previous assignments to handle capacitors
% and inductors. The program should read a file with the list of: resistors, currents sources,
% voltage sources, capacitors, and inductors. The syntax for specifying a capacitor is:
% 
%     Clabel node1 node2 val
% 
% where label is an arbitrary label, node1 and node2 are integer circuit node numbers, and val is
% the capacitance (a floating point number). The syntax for specifying an inductor is:
% 
%     Llabel node1 node2 val
% 
% where label is an arbitrary label, node1 and node2 are integer circuit node numbers, and val
% is the inductance (a floating point number). Explain how you handle inductors, and which
% stamp can be proposed to include them into the modified nodal analysis equations written in
% the form
%
%     G x(t)+ C x(t) = B u(t)
%
% where the column vector u(t) contains all sources.
%

C = [] ;

   %enableTrace() ;
   trace( ['filename: ', filename] ) ;

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

      trace( ['line: ', line] ) ;

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
      case '#'
         trace( ['comment line: ', line ] ) ;
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
      trace( sprintf( 'resistorLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, resistorLines(1:2, :) ) ;
   end
   sz = size( currentLines, 2 ) ;
   if ( sz )
      trace( sprintf( 'currentLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, currentLines(1:2, :) ) ;
   end
   sz = size( voltageLines, 2 ) ;
   if ( sz )
      trace( sprintf( 'voltageLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, voltageLines(1:2, :) ) ;
   end
   sz = size( ampLines, 2 ) ;
   if ( sz )
      trace( sprintf( 'ampLines: %d', sz ) ) ;

      allnodes = horzcat( allnodes, ampLines(1:2, :), ampLines(3:4, :) ) ;
   end
%disableTrace() ;
   maxNode = max( max( allnodes ) ) ;
   trace( [ 'maxnode: ', sprintf('%d', maxNode) ] ) ;

   %
   % Done parsing the netlist file.
   % 
   %----------------------------------------------------------------------------

   numVoltageSources = size( voltageLines, 2 ) ;
   numAmpSources = size( ampLines, 2 ) ;

   numAdditionalSources = numVoltageSources + numAmpSources ;

   % have to adjust these sizes for sources, and voltage control sources
   G = zeros( maxNode + numAdditionalSources, maxNode + numAdditionalSources ) ;
   b = zeros( maxNode + numAdditionalSources, 1 ) ;

   % process the resistor lines:
   % note: matlab for loop appears to iterate over matrix by assigning each column to a temp variable
   labelNumber = 0 ;
   for r = resistorLines
      labelNumber = labelNumber + 1 ;
      label     = resistorLables{labelNumber} ;
      plusNode  = r(1) ;
      minusNode = r(2) ;
      z         = 1/r(3) ;

      trace( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, 1/z ) ) ;

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

   % process the voltage sources:
   r = maxNode ;
   labelNumber = 0 ;
   for v = voltageLines
      r = r + 1 ;
      labelNumber = labelNumber + 1 ;
      label       = voltageLables{labelNumber} ;
      plusNode    = v(1) ;
      minusNode   = v(2) ;
      value       = v(3) ;
  
      trace( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

      if ( plusNode )
         G( r, plusNode ) = 1 ;
         G( plusNode, r ) = -1 ;
      end
      if ( minusNode )
         G( r, minusNode ) = -1 ;
         G( minusNode, r ) = 1 ;
      end

      b( r,1 ) = value ;
   end

   % value for r (fall through from loop above)
   % process the voltage controled lines
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

      trace( sprintf( '%s %d,%d (%d,%d) -> %d\n', label, plusNodeNum, minusNodeNum, plusControlNodeNum, minusControlNodeNum, gain ) ) ;

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
   end

   % process the current sources:
   labelNumber = 0 ;
   for i = currentLines
      labelNumber = labelNumber + 1 ;
      label       = currentLables{labelNumber} ;
      plusNode    = i(1) ;
      minusNode   = i(2) ;
      value       = i(3) ;

      trace( sprintf( '%s %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

      if ( plusNode )
         b( plusNode ) = b( plusNode ) - value ;
      end
      if ( minusNode )
         b( minusNode ) = b( minusNode ) + value ;
      end
   end
end
