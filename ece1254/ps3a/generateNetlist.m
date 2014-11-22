function r = generateNetlist( filename )

LengthsMM          = [ 6 ; 4 ; 3 ; 2 ] ;
ResistancePerCM    = [ 25 ; 35.7 ; 51.0 ; 51.0 ] ;
InductancePerCM    = [ 5 ; 7.14 ; 10.2 ; 10.2 ] ;
CapacitancePerCM   = [ 2 ; 1.4 ; 0.98 ; 0.98 ] ;
DeltaZMM           = 0.05 ;

ResistancePerMM  = ResistancePerCM / 10 ;
InductancePerMM  = InductancePerCM / 10 ;
CapacitancePerMM = CapacitancePerCM / 10 ;

ResistancePerSegment  = ResistancePerMM * DeltaZMM ;
InductancePerSegment  = InductancePerMM * DeltaZMM ;
CapacitancePerSegment = CapacitancePerMM * DeltaZMM ;

n = LengthsMM / DeltaZMM ;

r = [n, ResistancePerSegment, InductancePerSegment, CapacitancePerSegment] ;

fh = fopen( filename ) ;
if ( -1 == fh )
   error( 'NodalAnalysis:fopen', 'error opening file "%s"', filename ) ;
end

vssNode = 1 ;

lastNodeNumber = vssNode ;
currentSegmentNumber = 1 ;
junctions = zeros(4, 1) ;

for level = [1:4]
   for k = [1:level]
      for j = [1:n(level)]
         fprintf( 'R%d %d %d %f\n', currentSegmentNumber, lastNodeNumber, lastNodeNumber + 1, ResistancePerSegment(level) ) ;
         lastNodeNumber = lastNodeNumber + 1 ;
         fprintf( 'L%d %d %d %fe-9\n', currentSegmentNumber, lastNodeNumber, lastNodeNumber + 1, InductancePerSegment(level) ) ;
         lastNodeNumber = lastNodeNumber + 1 ;
         fprintf( 'C%d %d %d %fe-15\n', currentSegmentNumber, lastNodeNumber, 0, CapacitancePerSegment(level) ) ;

         currentSegmentNumber = currentSegmentNumber + 1 ;
      end

      junctions(level) =    
   end
end

close( fh ) ;
