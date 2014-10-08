
%
% Assumptions (many of which would be probably be invalid for more general spice netlist files).
%
% 1) The 'label' following the R, I, V, E is numeric.  This appears to be the case in all the example spice circuits of
%    http://www.allaboutcircuits.com/vol_5/chpt_7/8.html -- that may be a bad general assumption.
% 2) .end terminates the netlist
% 3) The first line of netlist is a (title) comment unless it starts with R, I, V, E.
% 4) The netlist file will always include a 0 (ground) node.  I haven't tried to check that.
% 5) There are no gaps in the node numbers.
% 6) I seem to recall that spice files allowed the constants to be specified with k, m, M modifiers.
%    I haven't tried to support that.
%

function [G,b] = NodalAnalysis(filename)
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

   %enableTrace() ;
   trace( ['filename: ', filename] ) ;

   currentLines = [] ;
   resistorLines = [] ;
   voltageLines = [] ;
   currentLines = [] ;
   ampLines = [] ;

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
      line = fgets( fh ) ;

      trace( ['line: ', line] ) ;

      switch line(1:1)
      case 'R'
         firstLineRead = 1 ;
         % Note: sscanf appears to treat ' ' as one or more spaces (which is what we want)
         [a, sz] = sscanf( line(2:end), '%d %d %d %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:R', 'expected 4 fields, but read %d fields from resistor line "%s"', sz, line ) ;
         end

         resistorLines(:,end+1) = a ;
      case 'E'
         firstLineRead = 1 ;
         [a, sz] = sscanf( line(2:end), '%d %d %d %d %d %f' ) ;
         if ( sz ~= 6 )
            error( 'NodalAnalysis:parseline:E', 'expected 6 fields, but read %d fields from controlling voltage line "%s"', sz, line ) ;
         end

         ampLines(:,end+1) = a ;
      case 'I'
         firstLineRead = 1 ;
         [a, sz] = sscanf( line(2:end), '%d %d %d DC %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:I', 'expected 4 fields, but read %d fields from current line "%s"', sz, line ) ;
         end

         currentLines(:,end+1) = a ;
      case 'V'
         firstLineRead = 1 ;
         [a, sz] = sscanf( line(2:end), '%d %d %d DC %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:V', 'expected 4 fields, but read %d fields from current line "%s"', sz, line ) ;
         end

         voltageLines(:,end+1) = a ;
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

   % if we wanted to allow for gaps in the node numbers (like 1, 3, 4, 5), then we'd have to count the number of unique node numbers
   % instead of just taking a max, and map the matrix positions to the original node numbers later.
   % 
   allnodes = zeros(2, 1) ;
   if ( size( resistorLines, 2 ) )
      allnodes = horzcat( allnodes, resistorLines(2:3, :) ) ;
   end
   if ( size( currentLines, 2 ) )
      allnodes = horzcat( allnodes, currentLines(2:3, :) ) ;
   end
   if ( size( voltageLines, 2 ) )
      allnodes = horzcat( allnodes, voltageLines(2:3, :) ) ;
   end
   if ( size( ampLines, 2 ) )
      allnodes = horzcat( allnodes, ampLines(2:3, :), ampLines(4:5, :) ) ;
   end
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
   for r = resistorLines
      label     = r(1) ;
      plusNode  = r(2) ;
      minusNode = r(3) ;
      z         = 1/r(4) ;

      trace( sprintf( 'R:%d %d,%d -> %d\n', label, plusNode, minusNode, 1/z ) ) ;

      % insert the stamp:
      if ( plusNode )
         G( plusNode, plusNode ) = z ;
         if ( minusNode )
            G( plusNode, minusNode ) = -z ;
            G( minusNode, plusNode ) = -z ;
         end
      end
      if ( minusNode )
         G( minusNode, minusNode ) = z ;
      end
   end

   % process the voltage sources:
   r = maxNode ;
   for v = voltageLines
      r = r + 1 ;

      label       = v(1) ;
      plusNode    = v(2) ;
      minusNode   = v(3) ;
      value       = v(4) ;
  
      trace( sprintf( 'V:%d %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

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
   for a = ampLines
      r = r + 1 ;

      label                = a(1) ;
      plusNodeNum          = a(2) ;
      minusNodeNum         = a(3) ;
      plusControlNodeNum   = a(4) ;
      minusControlNodeNum  = a(5) ;
      gain                 = a(6) ;

      trace( sprintf( 'E:%d %d,%d (%d,%d) -> %d\n', label, plusNodeNum, minusNodeNum, plusControlNodeNum, minusControlNodeNum, gain ) ) ;

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
   for i = currentLines
      label       = i(1) ;
      plusNode    = i(2) ;
      minusNode   = i(3) ;
      value       = i(4) ;

      trace( sprintf( 'I:%d %d,%d -> %d\n', label, plusNode, minusNode, value ) ) ;

      if ( plusNode )
         b( plusNode ) = b( plusNode ) - value ;
      end
      if ( minusNode )
         b( minusNode ) = b( minusNode ) + value ;
      end
   end
end

%clear all ; [G, b] = NodalAnalysis( 'test2.netlist' ) ;
%clear all ; [G, b] = NodalAnalysis( 'ps1.circuit.netlist' ) ; G\b
