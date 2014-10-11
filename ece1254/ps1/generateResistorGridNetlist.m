function generateResistorGridNetlist(filename, N)
% Write a small matlab function that generates a netlist for a network made by:
%
% • a N×N square grid of resistors of value R, where N is the number of
%   resistors per edge. The grid nodes are numbered from 1 to (N +1) 2 ;
% • a voltage source V = 1V connected between node 1 and ground;
% • three current sources, each one connected between a randomly-
%   selected node of the grid and the reference node. The source current
%   flows from the grid node to the reference node. Choose their value
%   randomly between 10 mA and 100 mA;
% 
% Assumptions
%
% 1) Reference node means ground.  
%     http://www.solved-problems.com/circuits/circuits-articles/525/reference-node-node-voltages/

   %enableTrace() ;
   trace( ['filename: ', filename] ) ;

   resistorNumber = 0 ;

   delete( filename ) ;

   fh = fopen( filename, 'w+' ) ;
   if ( -1 == fh )
      error( 'generateResistorGridNetlist:fopen', 'error opening file "%s"', filename ) ;
   end

   fprintf( fh, 'V1 1 0 DC 1\n' ) ;

   for j = 0:N
   for i = 1:N
      resistorNumber = resistorNumber + 1 ;

      fprintf( fh, 'R%d %d %d 0.2\n', resistorNumber, (N+1) * j + i, (N+1) * j + i + 1 ) ;
   end
   end

   for i = 1:(N+1)
   for j = 0:N
      resistorNumber = resistorNumber + 1 ;

      fprintf( fh, 'R%d %d %d 0.2\n', resistorNumber, j * (N+1) + i, j * (N+1) + i + (N+1) ) ;
   end
   end

   for i = 1:3
      currentNode = randi((N+1) * (N+1)) ;
      sourceValue = 0.01 + (0.1 - 0.01) * rand() ;
     
      fprintf( fh, 'I%d %d 0 DC %g\n', i, currentNode, sourceValue ) ;
   end

   fclose( fh ) ;
end
