function r = generateNetlist( filename )

if ( 0 )
   % for testing.  use less node numbers to verify the netlist node placement manually.
   LengthsMM          = [ 0.05 ; 0.05 ; 0.05 ; 0.05 ] ;
   %LengthsMM          = [ 0.15 ; 0.15 ; 0.15 ; 0.15 ] ;

   maxLevel = 2 ;
else
   LengthsMM          = [ 6 ; 4 ; 3 ; 2 ] ;

   maxLevel = 4 ;
end

ResistancePerCM    = [ 25 ; 35.7 ; 51.0 ; 51.0 ] ;
InductancePerCM    = [ 5 ; 7.14 ; 10.2 ; 10.2 ] * 1e-9 ; % nH
CapacitancePerCM   = [ 2 ; 1.4 ; 0.98 ; 0.98 ] * 1e-12 ; % 1 pF (picofarad, one trillionth (10−12) of a farad)
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
[ns, nx, nn] = generateNetlistSegment( fh, vssNode, vssNode + 1, 1, r, 1 ) ;

startNodeNumbers = [ns] ;
for level = [2:maxLevel]
   [endpoints, nn] = generateNetlistSegmentForLevel( fh, level, startNodeNumbers, max( startNodeNumbers ) + 1, nn, r ) ;

   traceit( sprintf('endpoints: %s\n', mat2str(endpoints)) );

   startNodeNumbers = endpoints ;
end

chipRes = 5e3 ;
chipCap = 5e-15 ;

fprintf( fh, '* chip blocks:\n' ) ;
for ns = startNodeNumbers
   fprintf( fh, 'R%d %d 0 %e\n', nn, ns, chipRes ) ;
   fprintf( fh, 'C%d %d 0 %e\n', nn, ns, chipCap ) ;

   nn = nn + 1 ;
end

fprintf( fh, '* scale this by the oscillatory voltage:\nV1 1 0 DC 1\n' ) ;

fclose( fh ) ;
