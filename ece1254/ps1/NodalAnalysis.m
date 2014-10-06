
%
% Assumptions (many of which would be probably be invalid for more general spice netlist files).
%
% 1) 'label' in [RIVE]label is numeric.  This appears to be the case in all the example spice circuits of
%    http://www.allaboutcircuits.com/vol_5/chpt_7/8.html -- may be a bad general assumption.
% 2) .end terminates the netlist
% 3) The first line of netlist is a (title) comment unless it starts with [RIVE]
% 4) The netlist file will always include a 0 (ground) node.
% 5) There are no gaps in the node numbers.
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

   enableTrace() ;
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
   allnodes = horzcat( resistorLines(2:3, :), currentLines(2:3, :), voltageLines(2:3, :), ampLines(2:3, :), ampLines(4:5, :) ) ;
   maxNode = max( max( allnodes ) ) ;
   trace( [ 'maxnode: ', sprintf('%d', maxNode) ] ) ;

   %
   % Done parsing the netlist file.
   % 
   %----------------------------------------------------------------------------

   numVoltageSources = size( voltageLines, 2 ) ;

   % have to adjust these sizes for sources, and amps
   G = zeros( maxNode + numVoltageSources, maxNode + numVoltageSources ) ;
   b = zeros( maxNode + numVoltageSources, 1 ) ;

   % process the resistor lines:
   % note: matlab for loop appears to iterate over matrix by assigning each column to a temp variable
   for r = resistorLines
      label = r(1) ;
      n1 = r(2) ;
      n2 = r(3) ;
      z = 1/r(4) ;

      trace( sprintf( 'R:%d %d,%d -> %d\n', label, n1, n2, 1/z ) ) ;

      % insert the stamp:
      if ( n1 )
         G( n1, n1 ) = z ;
         if ( n2 )
            G( n1, n2 ) = -z ;
            G( n2, n1 ) = -z ;
         end
      end
      if ( n2 )
         G( n2, n2 ) = z ;
      end
   end

   % process the voltage sources:
   r = maxNode ;
   for v = voltageLines
      r = r + 1 ;

      label = v(1) ;
      n1 = v(2) ;
      n2 = v(3) ;
      value = v(4) ;
  
      trace( sprintf( 'V:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;

      if ( n1 )
         G( n1, r ) = 1 ;
         G( r, n1 ) = -1 ;
      end
      if ( n2 )
         G( n2, r ) = -1 ;
         G( r, n2 ) = 1 ;
      end

      b( r,1 ) = value ;
   end

   % process the current sources:
   for i = currentLines
      label = i(1) ;
      n1 = i(2) ;
      n2 = i(3) ;
      value = i(4) ;

      trace( sprintf( 'I:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;

      if ( n1 )
         b( n1 ) = b( n1 ) - value ;
      end
      if ( n2 )
         b( n2 ) = b( n2 ) + value ;
      end
   end

   % process the (voltage) amplifier lines:
%      trace( sprintf( 'E:%d %d,%d (%d,%d) -> %d\n', label, n1, n2, nodectrl1, nodectrl2, gain ) ) ;
%        [label, n1, n2, nodectrl1, nodectrl2, gain] = a{:} ;
%
end

%clear all ; [G, b] = NodalAnalysis( 'test2.netlist' ) ;
