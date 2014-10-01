
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

% debug:
   trace( ['filename: ', filename] ) ;

   fh = fopen( filename ) ;
   if ( -1 == fh )
      error( 'NodalAnalysis:fopen', 'error opening file "%s"', filename ) ;
   end

   while ~feof( fh )
      line = fgets( fh ) ;

      switch line(1:1)
      case 'R'
         %[label, n1, n2, value] = textscan( '%d %d %d %d' ) ;
         out = textscan( line, '%d %d %d %d' ) ;
         %disp( ['R:', line(2:end)] ) ;
         s = sprintf( 'R %d,%d -> %d,%d', out{1}, out{2}, out{3}, out{4} ) ;
         disp( out{1} ) ;
         disp( out{2} ) ;
         disp( out{3} ) ;
         disp( out{4} ) ;
         disp( s ) ;
      case 'E'
         disp( ['E:', line(2:end)] ) ;
      case 'I'
         disp( ['I:', line(2:end)] ) ;
      case 'V'
         disp( ['V:', line(2:end)] ) ;
      otherwise
         error( 'NodalAnalysis:parseline', 'expect line "%s" to start with one of R,E,I,V', line ) ;
      end
   end

   d = 1 ;
   G = {1,1} ;
   b = {1,3} ;
end

%[G, b, d] = NodalAnalysis( 'x.netlist' ) ;
