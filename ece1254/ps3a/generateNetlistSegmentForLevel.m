function [endPoints, nn] = generateNetlistSegmentForLevel( fh, level, nsList, nx, nn, r )
% a function to print out all the RLC segments for a given level > 1.
%
% The current running total of the number of segments is returned,
% as well as all the terminal node numbers of the last segments of each branch.

endPoints = zeros( 1, (level - 1) * 2 ) ;

traceit( sprintf( 'level = %d, nsList = %s, nx = %d, nn = %d', level, mat2str(nsList), nx, nn ) ) ;

c = 0 ;
for thisNs = nsList
   for ep = [1:2]
      c = c + 1 ;
      fprintf( fh, '* level = %d, branch: %d (fork from node: %d)\n', level, c, thisNs ) ;
      [ns, nx, nn] = generateNetlistSegment( fh, thisNs, nx, nn, r, level ) ;

      traceit( sprintf('ep, ns, nx, nn = %d, %d, %d, %d', ep, ns, nx, nn ) ) ;
      endPoints(1, c) = ns ;
   end
end
