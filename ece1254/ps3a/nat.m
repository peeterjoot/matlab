clear all ;
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test2.netlist' ) ;
% this was a manual test case, was verified manually.

[G, C, B, x] = NodalAnalysis( '../ps1/testdata/ps1.circuit.netlist' ) ;
% this was the circuit of ps1.

% ps3a: example 1:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample1.netlist' ) ;

% constant voltage source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test3.netlist' ) ;

% constant current source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test4.netlist' ) ;
