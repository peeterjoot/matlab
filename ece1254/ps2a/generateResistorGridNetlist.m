function generateResistorGridNetlist(filename, N, R, Rg, Vs, Rs, withVoltageSource)
% Write a small matlab function that generates a netlist for a network made by:
%
% • a N×N square grid of resistors of value R, where N is the number of
%   resistors per edge. The grid nodes are numbered from 1 to (N +1)^2 ; Node 1 is a corner node
% • resistor R_g between each node of the grid and the reference node.
% • a non-ideal voltage source connected between node 1 and ground. The voltage source
%   has value V_s and internal (series) resistance R_s
% • three current sources, each one connected between a randomly-
%   selected node of the grid and the reference node. The source current
%   flows from the grid node to the reference node. Choose their value
%   randomly between 10 mA and 100 mA;
%
%   The source current must flow from the grid to the reference node as shown in fig. 1.1
%   (and not viceversa!). 

% 
% Assumptions
%
% 1) Reference node means ground.  
%     http://www.solved-problems.com/circuits/circuits-articles/525/reference-node-node-voltages/

   %enableTrace() ;
   trace( ['filename: ', filename] ) ;

   resistorNumber = 0 ;

   % this appeared neccessary, but was only due to a missing fclose() that was keeping the file handle open.
   %delete( filename ) ;

   fh = fopen( filename, 'w+' ) ;
   if ( -1 == fh )
      error( 'generateResistorGridNetlist:fopen', 'error opening file "%s"', filename ) ;
   end

% • a N×N square grid of resistors of value R, where N is the number of
%   resistors per edge. The grid nodes are numbered from 1 to (N +1)^2 ; Node 1 is a corner node
   for j = 0:N
   for i = 1:N
      resistorNumber = resistorNumber + 1 ;

      fprintf( fh, 'R%d %d %d %g\n', resistorNumber, (N+1) * j + i, (N+1) * j + i + 1, R ) ;
   end
   end

   for i = 1:N+1
   for j = 0:N-1
      resistorNumber = resistorNumber + 1 ;
      n = j * (N+1) + i ;
      trace( sprintf('Rs%d: node: %d', resistorNumber, n) ) ;

      fprintf( fh, 'R%d %d %d %g\n', resistorNumber, n, n + N + 1, R ) ;
   end
   end

% • resistor R_g between each node of the grid and the reference node.
   for i = 1:N+1
   for j = 1:N+1
      resistorNumber = resistorNumber + 1 ;

      n = (j-1) * (N+1) + i ;

      fprintf( fh, 'Rg%d %d 0 %g\n', resistorNumber, n, Rg ) ;
   end
   end

   if ( withVoltageSource )
      % • a non-ideal voltage source connected between node 1 and ground. The voltage source
      %   has value V_s and internal (series) resistance R_s
      fprintf( fh, 'V1 1 %d DC %g\n', (N+1)^2 + 1, Vs ) ;
      fprintf( fh, 'Rs %d 0 %g\n', (N+1)^2 + 1, Rs ) ;
   else
      fprintf( fh, 'I1 1 0 DC %g\n', Vs/Rs ) ;
      fprintf( fh, 'Rs 1 0 %g\n', Rs ) ;
   end

   minCurrentSourceAmperage = 0.01 ;
   maxCurrentSourceAmperage = 0.1 ;

   for i = 1:3
      currentNode = randi((N+1) * (N+1)) ;
      sourceValue = minCurrentSourceAmperage + (maxCurrentSourceAmperage - minCurrentSourceAmperage) * rand() ;
     
      fprintf( fh, 'I%d %d 0 DC %g\n', i, currentNode, sourceValue ) ;
   end

   fclose( fh ) ;
end
