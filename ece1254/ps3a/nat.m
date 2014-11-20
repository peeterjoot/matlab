clear all ;
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test2.netlist' ) ;
% a manual test case

[G, C, B, x] = NodalAnalysis( '../ps1/testdata/ps1.circuit.netlist' ) ;
% circuit of ps1.

%-------------------
% ps3a: example 1:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample1.netlist' ) ;

% ps3a: example 2:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample2.netlist' ) ;

% ps3a: example 3:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample3.netlist' ) ;

% ps3a: example 3: with inductor sign reversed:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample3b.netlist' ) ;
%-------------------

% constant voltage source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test3.netlist' ) ;

% constant current source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test4.netlist' ) ;
