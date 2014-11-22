function [nn, ns] = generateNetlistSegment( fh, ns, nx, nn, r, level )
% print out the netlist data for n segments of a transmission line, all connected in serial, having the following model:
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
%   - nn: one greater than the last segment number that has been used.
%   - ns: the value of (nx+1) for the last segment that was printed (last node number in this portion of the transmission line)
%

n = r( level, 1 ) ;
res = r( level, 2 ) ;
ind = r( level, 3 ) ;
cap = r( level, 4 ) ;

traceit( sprintf('ns = %d', ns ) ) ;
traceit( sprintf('nn = %d', nn ) ) ;
traceit( sprintf('level = %d', level ) ) ;
traceit( sprintf('n, res, ind, cap = %d, %f, %f, %f', n, res, ind, cap ) ) ;

for j = [1:n]
   fprintf( fh, 'R%d %d %d %f\n', nn, ns, nx, res ) ;
   fprintf( fh, 'L%d %d %d %fe-9\n', nn, nx, nx + 1, ind ) ;
   fprintf( fh, 'C%d %d %d %fe-15\n', nn, nx + 1, 0, cap ) ;

   ns = nx + 1 ;
   nx = nx + 2 ;
   nn = nn + 1 ;
end

