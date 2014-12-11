These are now the only .m files that aren't copied from other locations:

FourierMatrix.m
gnl.m
Gprime.m

HBSolve.m
   Harmonic Balance workhorse. 

TestSolver.m
   Generates the cputime/error plotsk

PlotWaveforms.m
   Calls HBSolve() for a netlist file and caches the result.  Then plots the results using a set 
   of plot specifications.

makefigures.m
   Driver for all the plots.  Calls PlotWaveforms()
