
%
% Assumptions:
% 1) 'label' in [RIVE]label is numeric.  This appears to be the case in all the example spice circuits of
%    http://www.allaboutcircuits.com/vol_5/chpt_7/8.html
% 2) .end terminates the netlist
% 3) The first line of netlist is a (title) comment unless it starts with [RIVE]
% 4) The netlist file will always include a 0 (ground) node.
%
% Not implementing the spice netlist format where:
%

function [G,b,d] = NodalAnalysis(filename)
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
% where â€œvalueâ€? is the resistance value. Current sources are specified with
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
% where node+ and node- identify, respectively, the node where the â€œposi-
% tiveâ€? and â€œnegativeâ€? terminal is connected to. A voltage-controlled volt-
% age source, connected between the nodesnode+ and node-, is specified
% by the line
% 
% Elabel node+ node- nodectrl+ nodectrl- gain
% 
% The controlling voltage is between the nodes nodectrl+ and nodectrl-,
% and the last argument is the source gain.

   enableTrace() ;
   trace( ['filename: ', filename] ) ;

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
         [amat, sz] = sscanf( line(2:end), '%d %d %d %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:R', 'expected 4 fields, but read %d fields from resistor line "%s"', sz, line ) ;
         end

         % http://stackoverflow.com/a/26190231/189270
         % http://www.mathworks.com/help/matlab/ref/deal.html?refresh=true, example 3:
         a = num2cell( amat ) ;
         [label, n1, n2, value] = a{:} ;
%         label = amat(1) ;
%         n1    = amat(2) ;
%         n2    = amat(3) ;
%         value = amat(4) ;

         trace( sprintf( 'R:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
      case 'E'
         firstLineRead = 1 ;
         [amat, sz] = sscanf( line(2:end), '%d %d %d %d %d %f' ) ;
         if ( sz ~= 6 )
            error( 'NodalAnalysis:parseline:E', 'expected 6 fields, but read %d fields from controlling voltage line "%s"', sz, line ) ;
         end

         a = num2cell( amat ) ;
         [label, n1, n2, nodectrl1, nodectrl2, gain] = a{:} ;
%         label     = amat(1) ;
%         n1        = amat(2) ;
%         n2        = amat(3) ;
%         nodectrl1 = amat(4) ;
%         nodectrl2 = amat(5) ;
%         gain      = amat(6) ;

         trace( sprintf( 'I:%d %d,%d (%d,%d) -> %d\n', label, n1, n2, nodectrl1, nodectrl2, gain ) ) ;
      case 'I'
         firstLineRead = 1 ;
         [amat, sz] = sscanf( line(2:end), '%d %d %d DC %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:I', 'expected 4 fields, but read %d fields from current line "%s"', sz, line ) ;
         end

         a = num2cell( amat ) ;
         [label, n1, n2, value] = a{:} ;
%         label = amat(1) ;
%         n1    = amat(2) ;
%         n2    = amat(3) ;
%         value = amat(4) ;

         trace( sprintf( 'I:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
      case 'V'
         firstLineRead = 1 ;
         [amat, sz] = sscanf( line(2:end), '%d %d %d DC %f' ) ;
         if ( sz ~= 4 )
            error( 'NodalAnalysis:parseline:V', 'expected 4 fields, but read %d fields from current line "%s"', sz, line ) ;
         end

         a = num2cell( amat ) ;
         %[label, n1, n2, value] = a{:} ;
%         label = amat(1) ;
%         n1    = amat(2) ;
%         n2    = amat(3) ;
%         value = amat(4) ;

         trace( sprintf( 'V:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
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

   d = 1 ;
   G = {1,1} ;
   b = {1,3} ;
end

%clear all ; [G, b, d] = NodalAnalysis( 'test2.netlist' ) ;
