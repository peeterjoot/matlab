-------------------------------------------------------------------
Infrastructure:

   NodalAnalysis.m

      Parse the netlist file and return the time domain MNA equation matrices and an
      encoding of any non-linear elements.
      
   FourierMatrixComplex.m

      Compute the "Small F" fourier matrix for the discrete fourier transform.

   HarmonicBalance.m
      Construct the Frequency domain equivalents of the linear portions of the network.
      Consumes results from NodalAnalysis().

-------------------------------------------------------------------
"Big F" solver:

   FourierMatrix.m
      Compute the "Big F" fourier matrix for the discrete fourier transform and its inverse.

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
   DiodeExponentialDFT.m
   DiodeExponentialJacobian.m
   NewtonsHarmonicBalance.m

-------------------------------------------------------------------
Plotting and test related:

   TestSolver.m
      Generates the cputime/error plots

   PlotWaveforms.m
      Calls HBSolve() for a netlist file and caches the result.  Then plots the results using a set 
      of plot specifications.

   makefigures.m
      Driver for all the plots.  Calls PlotWaveforms()

   testFourierMatrixComplex.m
      verification that vectorized construction of "small F" matrix works as expected.

   testH.m
      small F manual unit test driver.
-------------------------------------------------------------------
