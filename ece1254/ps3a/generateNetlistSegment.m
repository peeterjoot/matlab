function [currentSegmentNumber, lastNodeNumber] = generateNetlistSegment( fh, startNodeNum, nextSegmentNumber, n, res, ind, cap )
% print out the netlist data for n segments, each of the following form:
%
% o----- R ------o------- L -------o
%       (res)           (ind)      |
%                                  |
%                                  C (cap)
%                                  |
%                                  |
%                                 ---
%                                  -
%                                  .
%
% The current running total of the number of segments is returned, as well as the terminal node number of the last segment.

lastNodeNumber = startNodeNum ;
currentSegmentNumber = nextSegmentNumber ;

for j = [1:n]
   fprintf( fh, 'R%d %d %d %f\n', currentSegmentNumber, lastNodeNumber, lastNodeNumber + 1, res ) ;
   lastNodeNumber = lastNodeNumber + 1 ;
   fprintf( fh, 'L%d %d %d %fe-9\n', currentSegmentNumber, lastNodeNumber, lastNodeNumber + 1, ind ) ;
   lastNodeNumber = lastNodeNumber + 1 ;
   fprintf( fh, 'C%d %d %d %fe-15\n', currentSegmentNumber, lastNodeNumber, 0, cap ) ;

   currentSegmentNumber = currentSegmentNumber + 1 ;
end
