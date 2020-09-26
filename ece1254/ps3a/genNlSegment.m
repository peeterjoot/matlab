function [ns, nx, nn] = generateNetlistSegment( fh, ns, nx, nn, r, level )
% Print out the netlist data for n segments of a transmission line, all connected in serial, having the following model:
%
% (ns)              (nx)                (nx+1)
%  o----- R_nn ------o------- L_nn -------o
%        (res)                (ind)       |
%                                         |
%                                         C_nn (cap)
%                                         |
%                                         |
%                                        ---
%                                         -
%                                         .
%
% inputs:
%   - fh: file handle to print .netlist fragment to.
%   - ns: start node number for the first segment.
%   - nx: node number for the resistor/inductor connection as depicted above.
%   - nn: next segment index.  This is the index for each of the resistor/inductor/capacitor triplet of this part of the
%         transmission line.
%
%  After printing each segment, ns/nx/nn are each updated to the start-node-number/next-node-number/next-segment-number
%  for the next segment.
%
% outputs:
%   - ns: the last node number of the sequence of segments printed in this pass.
%   - nx: the next node number available for use.
%   - nn: the next segment number available for use.
%

n = r( level, 1 ) ;
res = r( level, 2 ) ;
ind = r( level, 3 ) ;
cap = r( level, 4 ) ;

traceit( sprintf('ns = %s, nx = %s, nn = %s, level = %s', ns, nx, nn, level ) ) ;
%traceit( sprintf('n, res, ind, cap = %d, %f, %f, %f', n, res, ind, cap ) ) ;

for j = [1:n]
   fprintf( fh, 'R%d %d %d %e\n', nn, ns, nx, res ) ;
   fprintf( fh, 'L%d %d %d %e\n', nn, nx, nx + 1, ind ) ;
   fprintf( fh, 'C%d %d %d %e\n', nn, nx + 1, 0, cap ) ;

   ns = nx + 1 ;
   nx = nx + 2 ;
   nn = nn + 1 ;
end
