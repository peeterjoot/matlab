
%
% Assumptions:
% 1) 'label' in [RIVE]label is numeric.  This appears to be the case in all the example spice circuits of
%    http://www.allaboutcircuits.com/vol_5/chpt_7/8.html
%
% Not implementing the spice netlist format where:
% a) .end terminates the netlist
% b) first line of netlist is a comment unless it starts with [RIVE]
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

   while ~feof( fh )
      line = fgets( fh ) ;

      trace( ['line: ', line] ) ;

      switch line(1:1)
      case 'R'
         [label, n1, n2, value] = sscanf( line(2:end), '%d %d %d %f' ) ;          

         trace( sprintf( 'R:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
      case 'E'
         [label, n1, n2, c1, c2, value] = sscanf( line(2:end), '%d %d %d %d %d %f' ) ;          

         trace( sprintf( 'I:%d %d,%d (%d,%d) -> %d\n', label, n1, n2, c1, c2, value ) ) ;
      case 'I'
         [label, n1, n2, value] = sscanf( line(2:end), '%d %d %d DC %f' ) ;          

         trace( sprintf( 'I:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
      case 'V'
         [label, n1, n2, value] = sscanf( line(2:end), '%d %d %d DC %f' ) ;          

         trace( sprintf( 'V:%d %d,%d -> %d\n', label, n1, n2, value ) ) ;
      otherwise
         error( 'NodalAnalysis:parseline', 'expect line "%s" to start with one of R,E,I,V', line ) ;
      end
   end

   d = 1 ;
   G = {1,1} ;
   b = {1,3} ;
end

%[G, b, d] = NodalAnalysis( 'test2.netlist' ) ;
