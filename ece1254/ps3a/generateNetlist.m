function [r, endpoints] = generateNetlist( filename, LengthsMM )
% As test system, we consider the network in fig. 1.1 which distributes the clock signal to 8
% blocks of an integrated circuit. The network is in the form of a binary tree with four levels.
% Each segment is a transmission line with characteristics (length, per-unit-length parameters)
% given in table 1.1.
%
% Level Length Resistance p.u.l Inductance p.u.l. Capacitance p.u.l.
%       [mm]   R[Ω / cm]        L[nH / cm]        C[pF / cm]
% 1     6      25               5.00              2.00
% 2     4      35.7             7.14              1.40
% 3     3      51.0             10.2              0.98
% 4     2      51.0             10.2              0.98
%
% Divide each transmission line into segments of length ∆z = 0.05mm, and
% model each segment with an RLC circuit as the one shown in the figure.
%
% Model the clock source with a periodic voltage source with the following characteristics:
% amplitude 1 V, rise/fall time 100 ps, period 2 ns, duty cycle 50%, initial delay 100 ps. The clock
% source voltage is depicted in fig. 1.2.
%
% parameters:
% [in] filename: netlist file to be generated is saved to this path.
% [in] LengthsMM (optional):
%     For test purposes, override the builtin LengthsMM with a different set of lengths.
%     Example:
%        LengthsMM          = [ 0.05 ; 0.05 ; 0.05 ; 0.05 ] ;
%        LengthsMM          = [ 0.05 ; 0.05 ] ;
%        LengthsMM          = [ 0.15 ; 0.15 ; 0.15 ; 0.15 ] ;
%
% LengthsMM must have at least 2 rows, and no more than 4.  The default value for this parameter is:
%
%   LengthsMM          = [ 6 ; 4 ; 3 ; 2 ] ;
%
% (that of the problem specification)
%
% Output:
%    r: table of in the RLC values per segment (to use in the problem set report).
%    endpoints: nodenumbers for the loads on the circuit.  We are interested in the voltage at one of these points.
%
% Notes:
% - clock signal is implemented in vclock().

if ( nargin < 2 )
   LengthsMM          = [ 6 ; 4 ; 3 ; 2 ] ;
end
maxLevel = size( LengthsMM, 1 ) ;

ResistancePerCM    = [ 25 ; 35.7 ; 51.0 ; 51.0 ] ;
InductancePerCM    = [ 5 ; 7.14 ; 10.2 ; 10.2 ] * 1e-9 ; % nH (nanoHenry, one billionth (10^-9) of a Henry)
CapacitancePerCM   = [ 2 ; 1.4 ; 0.98 ; 0.98 ] * 1e-12 ; % 1 pF (picofarad, one trillionth (10−12) of a farad)

if ( maxLevel < 4 )
   ResistancePerCM    = ResistancePerCM( 1:maxLevel ) ;
   InductancePerCM    = InductancePerCM( 1:maxLevel ) ;
   CapacitancePerCM   = CapacitancePerCM( 1:maxLevel ) ;
end

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
   error( 'generateNetlist:fopen', 'error opening file "%s"', filename ) ;
end

vssNode = 1 ;

% The first segment has no forks.
[ns, nx, nn] = generateNetlistSegment( fh, vssNode, vssNode + 1, 1, r, 1 ) ;

startNodeNumbers = [ns] ;
for level = [2:maxLevel]
   [endpoints, nn] = generateNetlistSegmentForLevel( fh, level, startNodeNumbers, max( startNodeNumbers ) + 1, nn, r ) ;

   traceit( sprintf('endpoints: %s\n', mat2str(endpoints)) ) ;

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
