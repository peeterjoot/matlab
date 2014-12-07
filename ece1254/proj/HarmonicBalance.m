function [Y, B, I, u, Vnames] = HarmonicBalance(G, C, B, bdiode, u, xnames, N, omega)
% HarmonicBalance generates the Harmonic balance modified nodal analysis (MNA) equations from the time domain MNA
% representation.
%
%    Y V = B U = I + ~I,                        (1)
%
% where ~I represents non-linear contributions not returned directly as a matrix.
% 
% The Harmonic balance results returned are associated with the time domain equations
%
%    G x(t) + C \dot{x}(t)= B u(t),             (2)
%
% as returned from HarmonicBalance(), 
% where the column vector u(t) contains all sources, and x(t) is a vector of all the sources.
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
% Y has the block diagonal structure
% 
%    Y = [ {G + j omega n}_n \delta_{nm} ]_{nm}                      (7)
% 
%---------------------------------------------------------------------------------------
%
% INPUT PARAMETERS:
%
% FIXME: parameters from NodalAnalysis.
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
% FIXME: Returned VARIABLES:
%
% With R equal to the total number of MNA variables, the returned parameters
% 
% - G [array]
% 
%    RxR matrix of resistance stamps.
% 
% - C [array]   
% 
%    RxR matrix of stamps for the time dependent portion of the MNA equations.
% 
% - B [array]
% 
%    RxM matrix of constant source terms.  Each column encodes the current sources 
%    for increasing frequencies.  For example, if there are DC sources in 
%    the circuit the first column would have contributions from the DC sources, 
%    and any columns after that would be for higher frequencies.
% 
% - u [array]
%   
%    Mx1 matrix of frequencies, ordered from lowest to highest.  
%    A zero value (in the 1,1 position) represents a DC source.
% 
% - xnames [cell]
% 
%   is an Rx1 array of strings for each of the variables in the resulting system.  
%   Entries will be added to this for each node voltage in the system.  
%   Current variables will be added for each DC voltage source, each DC voltage
%   controlled voltage source, as well as any inductor currents.
% 
%------------------------------------------------

   traceit( ['N, omega: ', N, omega] ) ;

   twoNplusOne = 2 * N + 1 ;
   
   R = size( G, 1 ) ;
   if ( R ~= size(G, 2) )
      error( 'HarmonicBalance:squareCheck:R', 'expected G with size (%d,%d) to be square', R, size(G, 2) ) ;
   end

   Y = zeros( twoNplusOne * R, twoNplusOne * R ) ;
   Vnames = cell( twoNplusOne * R, 1 ) ;
   I = [] ; % FIXME
   u = [] ; % FIXME
   B = [] ; % FIXME

   jOmega = j * omega ;

   r = 0 ;
   s = 0 ;
   for n = -N:N
      for m = 1:R
         r = r + 1 ;
         Vnames{r} = sprintf( '%s:%d', xnames{m}, n ) ;
      end

      Y( s+1:s+R, s+1:s+R ) = G + jOmega * n * C ;
      s = s + R ;
   end
end
