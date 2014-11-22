function r = generateNetlist( filename )

LengthsMM          = [ 0.05 ; 0.05 ; 0.05 ; 0.05 ] ;
%LengthsMM          = [ 0.2 ; 0.15 ; 0.1 ; 0.05 ] ;
%LengthsMM          = [ 6 ; 4 ; 3 ; 2 ] ;
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

fh = fopen( filename, 'w+' ) ;
if ( -1 == fh )
   error( 'NodalAnalysis:fopen', 'error opening file "%s"', filename ) ;
end

vssNode = 1 ;

% The first segment has no forks.
[currentSegmentNumber, lastNodeNumber] = generateNetlistSegment( fh, vssNode, vssNode + 1, 1, r, 1 ) ;

startNodeNumbers = [lastNodeNumber] ;
for level = [2:2]
% FIXME: have to pass in the next node number available.
   [endpoints, currentSegmentNumber] = generateNetlistSegmentForLevel( fh, startNodeNumbers, currentSegmentNumber, r ) ;

   traceit( sprintf('endpoints: %s\n', mat2str(endpoints)) );

   startNodeNumbers = endpoints ;
end

fclose( fh ) ;
