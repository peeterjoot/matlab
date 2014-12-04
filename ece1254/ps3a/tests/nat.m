% run manually and individually from ../

%-------------------
% ps3a: example 1:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample1.netlist' ) ;
% pass.

% ps3a: example 2:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample2.netlist' ) ;
% pass.

% ps3a: example 3:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample3.netlist' ) ;
% pass.

% ps3a: example 3: with inductor sign reversed:
[G, C, B, x] = NodalAnalysis( 'testdata/ps3a_sample3b.netlist' ) ;
% pass.
%-------------------

% constant voltage source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test3.netlist' ) ;
% pass.

% constant current source test case:
[G, C, B, x] = NodalAnalysis( '../ps1/testdata/test4.netlist' ) ;
% pass.
