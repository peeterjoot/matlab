These are now the only .m files that aren't copied from other locations:

FourierMatrix.m
   Compute the fourier matrix for the discrete fourier transform and its inverse.

gnl.m
   Determines the nonlinear contribution to the currents.

Gprime.m
   Produces the nonlinear contribution to the Jacobean
   required to solve a nonlinear circuit using Newton's Method

HBSolve.m
   Harmonic Balance workhorse. 

TestSolver.m
   Generates the cputime/error plots

PlotWaveforms.m
   Calls HBSolve() for a netlist file and caches the result.  Then plots the results using a set 
   of plot specifications.

makefigures.m
   Driver for all the plots.  Calls PlotWaveforms()
