-------------------------------------------------------------------
Infrastructure:

   NodalAnalysis.m

      Parse the netlist file and return the time domain MNA equation matrices and an
      encoding of any non-linear elements.
      
   HarmonicBalance.m
      Construct the Frequency domain equivalents of the linear portions of the network.
      Consumes results from NodalAnalysis().

   FourierMatrixComplex.m

      Compute the "Small F" Fourier matrix for the discrete Fourier transform.

   FourierMatrix.m
      Compute the "Big F" Fourier matrix for the discrete Fourier transform and its inverse.

-------------------------------------------------------------------
"Big F" solver:

   gnl.m
      Determines the nonlinear contribution to the currents.

   Gprime.m
      Produces the nonlinear contribution to the Jacobian
      required to solve a nonlinear circuit using Newton's Method

   HBSolve.m
      Harmonic Balance workhorse. 

-------------------------------------------------------------------
"Small F" solver:

   DiodeCurrentAndJacobian.m

      Do the V dependent parts of the I(V) and J(V) current and Jacobian calculations.

   DiodeNonVdependent.m

      Precalculate matrices that can be used repeatedly in DiodeCurrentAndJacobian.

-------------------------------------------------------------------
Plotting and test related:

   TestSolver.m
      Generates the cputime/error plots

   PlotWaveforms.m
      Calls HBSolve() or NewtonsHarmonicBalance() for a netlist file and caches the result.
      Then plots the results using a set 
      of plot specifications.

   makefigures.m
      Driver for all the plots.  Calls PlotWaveforms()

   testFourierMatrixComplex.m
      verification that vectorized construction of "small F" matrix works as expected.

   testH.m
      small F manual unit test driver.
-------------------------------------------------------------------
