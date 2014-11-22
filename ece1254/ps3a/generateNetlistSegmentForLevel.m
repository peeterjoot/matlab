function [endPoints, nextSegmentNumber] = generateNetlistSegmentForLevel( fh, startNodeNumbers, inSegmentNumber, r )
% a function to print out all the RLC segments for a given level > 1.
%
% The current running total of the number of segments is returned,
% as well as all the terminal node numbers of the last segments of each branch.

nextSegmentNumber = inSegmentNumber ;

prevlevel = size( startNodeNumbers, 1 ) ;
level = prevlevel + 1 ;
endPoints = zeros( level, 1 ) ;

n = r( level, 1 ) ;
res = r( level, 2 ) ;
ind = r( level, 3 ) ;
cap = r( level, 4 ) ;

traceit( sprintf( 'level = %d, n = %d, res = %f, ind = %f, cap = %f', level, n, res, ind, cap ) ) ;

ep = 0 ;
for ns = startNodeNumbers
   ep = ep + 1 ;   

%                            ns       nx           nn
%generateNetlistSegment( fh, vssNode, vssNode + 1, 1, r, 1 ) ;

% FIXME: have to pass in the next node number available.
   [nextSegmentNumber, lastNodeNumber] = generateNetlistSegment( fh, ns, nextSegmentNumber, r, level ) ;
   traceit( sprintf('ep = %d, lastNodeNumber = %s', ep, mat2str(lastNodeNumber) ) ) ;
   endPoints(ep, 1) = lastNodeNumber ;

   ep = ep + 1 ;   
% FIXME: have to pass in the next node number available.
   [nextSegmentNumber, lastNodeNumber] = generateNetlistSegment( fh, ns, nextSegmentNumber, r, level ) ;
   traceit( sprintf('ep = %d, lastNodeNumber = %s', ep, mat2str(lastNodeNumber) ) ) ;
   endPoints(ep, 1) = lastNodeNumber ;
end
