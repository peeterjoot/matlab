function [Gd, Vnames, I, F, Fbar] = HarmonicBalance(G, C, B, angularVelocities, D, bdiode, xnames, N, omega)
% HarmonicBalance generates the Harmonic balance modified nodal analysis (MNA) equations from the time domain MNA
% representation.
%
%    Gd V = B U = I + ~I,                                           (1)
%
% where ~I represents non-linear contributions not returned directly as a matrix.
% 
% The Harmonic balance results returned are associated with the time domain equations
%
%    G x(t) + C \dot{x}(t)= B angularVelocities(t) + D bdiode(t),  (2)
%
% as returned from HarmonicBalance(), 
% where the column vector angularVelocities(t) contains all sources, and x(t) is a vector of all the sources.
%
% Here V = [ 
%    V_{-N}^(1) 
%    V_{-N}^(2) 
%    .
%    .
%    .
%    V_{1-N}^(1) 
%    V_{1-N}^(2) 
%    .
%    .
%    .
%    V_{0}^(1) 
%    V_{0}^(2) 
%    .
%    .
%    .
%    V_{N-1}^(1) 
%    V_{N-1}^(2) 
%    .
%    .
%    .
%    V_{N}^(1) 
%    V_{N}^(2) 
%    .
%    .
%    .
%   ] 
%
% is a vector of DFT Fourier coefficients, defined by the transform pair:
%
%     x_k = \sum_{n = -N}^N X_k e^{j omega n t_k}                    (3)
%     X_k = (1/(2 N + 1)) \sum_{n = -N}^N x_k e^{-j omega n t_k}     (4)
%     t_k = T k/(2 N + 1)                                            (5)
%     omega T = 2 pi                                                 (6)
% 
% Gd has the block diagonal structure
% 
%    Gd = [ {G + j omega n}_n \delta_{nm} ]_{nm}                      (7)
% 
%---------------------------------------------------------------------------------------
%
% INPUT PARAMETERS:
%
% This function consumes all the output parameters of:
%
%    [G, C, B, bdiode, angularVelocities, xnames] = NodalAnalyis()
% 
% which should be passed here in the same order.  In addition to those, also pass:
%
% - N [integer]:
%
%     The number of frequencies to include in the bandwith limited Fourier representation (3)
%
% - omega [double]:
% 
%     The base frequency for all the higher level harmonics.
%
%------------------------------------------------
%
% With R equal to the total number of MNA variables, the returned parameters
% 
% - Gd [array]
% 
%    R(2N+1) x R(2N+1) matrix, where the 2N+1 RxR matrices down the diagonal are formed from sums of G's and (j omega n C)'s
% 
% - I [array]
% 
%    R x (2 N + 1) matrix of linear source Fourier coefficients.
% 
% - Vnames [cell]
% 
%   is an R x (2 N + 1) array of strings for each of the Fourier coefficient variables in the frequency domain equations.
%
%   The R entries are composed of: 
%   - Entries for each node voltage in the system.  
%   - Entries for each current variable flowing through a voltage source, a voltage
%     controlled voltage source, an inductor, or a diode (this last also treated as a current source).
%     When there are diodes, there will also be a non-linear portion of the diode model to handle separately.
% 
% - FIXME: handle non-linear diode stuff and return something for that.
% 
%------------------------------------------------

   traceit( ['N, omega: ', N, omega] ) ;

   twoNplusOne = 2 * N + 1 ;
   
   R = size( G, 1 ) ;
   if ( R ~= size(G, 2) )
      error( 'HarmonicBalance:squareCheck:R', 'expected G with size (%d,%d) to be square', R, size(G, 2) ) ;
   end

   Gd = zeros( twoNplusOne * R, twoNplusOne * R ) ;
   Vnames = cell( twoNplusOne * R, 1 ) ;
   I = zeros( twoNplusOne * R, 1 ) ;

   jOmega = j * omega ;

   r = 0 ;
   s = 0 ;
   q = 0 ;
   for n = -N:N
      for m = 1:R
         r = r + 1 ;
         Vnames{r} = sprintf( '%s:%d', xnames{m}, n ) ;
      end

      Gd( s+1:s+R, s+1:s+R ) = G + jOmega * n * C ;
      s = s + R ;

      thisOmega = omega * n ;
      omegaIndex = find( angularVelocities == thisOmega ) ;

      traceit( sprintf('HarmonicBalance: n=%d, thisOmega = %e, omegaIndex = %s', n, thisOmega, mat2str( omegaIndex ) ) ) ;
   
      if ( size(omegaIndex) == size(1) )
         % found one (not an error not to find a matching frequency.  Our input sources may not have all the frequencies that 
         % we allow in our bandwidth limited Harmonic Balance DFT representation.

         I( q+1:q+R ) = B( :, omegaIndex ) ;
      end
      q = q + R ;
   end

   F = FourierMatrixComplex( N ) ;

   % precalculate the conjugate since we need it repeatedly.
   Fbar = conj( F ) ;
end
