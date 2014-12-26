function partH( plotGershgorinCircles, withPreconditioning )
% collect timing data for each of the part (e) solution methods.
% withPreconditioning: boolean [in].
% plotGershgorinCircles: boolean [in].

N = 20 ;
R = [ 0.1 1 10 ] ;
%R = [ 0.1 ] ;

[fileExtension, savePlot] = saveHelper() ;

% sample points for circle plot
np = 30 ;

% made a second use of my Gershgorin plot stackoverflow question,
% initially asked to generate a Gershgorin plot for my notes:
%
% http://stackoverflow.com/questions/26515957/plot-discrete-points-and-some-circles-that-enclose-them-in-matlab
%

if ( withPreconditioning )
   fignum = 9 ;
else
   fignum = 6 ;
end
for r = R
   if ( 0 )
      % test plot logic with fewer points:
      G = sprandsym( 6, 0.5, 1:6 ) ;
   else
      % run: generateNodalEquationsPartEH(0) first:
      savename = sprintf( 'nodal.N%d.R%d.mat', N, r ) ;
      load( savename ) ;
   end

   if ( withPreconditioning )
      P = tridiagonal( G ) ;
   else
      P = [] ;
   end

   if ( plotGershgorinCircles )

      showSymmetryDebug = 0 ;

      if ( withPreconditioning )
%save('a.mat') ;
         %pInvHalf = inv( sqrt( P ) ) ;

         % using the direct calculation of P^{-1/2} 
         % results in the eigenvalues of G going off the real axis.  (matrices have many square roots
         % so that must have been one, but not the real root wanted).

         [v, d] = eig( full(P) ) ;
         pInvHalf = v * sqrt(d) * inv(v) ;

         if ( showSymmetryDebug )
            disp( r ) ;
            disp( max(max(abs(full(G - G.')))) ) ;
            disp( max(max(abs(full(P - P.')))) ) ;
            disp( max(max(abs( pInvHalf - pInvHalf.' ))) ) ;
         end

         G = pInvHalf * G * pInvHalf ;

         if ( showSymmetryDebug )
            disp( max(max(abs(full(G - G.')))) ) ;
         end
      end

      if ( ~showSymmetryDebug )
         e = eig( G ) ;

         f = figure ;
         scatter( real(e), imag(e), 'r.' ) ;
         hold on ;
         xlabel( 'Re({\lambda})' ) ;
         ylabel( 'Im({\lambda})' ) ;
         title( sprintf( 'R = %g', r ) ) ;

         sz = size(G, 1) ;
         for i = 1:sz
            % Gershgorin:
            % | \lambda - G_ii | < sum_{j\ne i} | G_ij |

            gii = G(i,i) ;
            radius = sum(abs(G(i,:))) - abs(G(i,i)) ;

            z = gii + radius * exp(1j * 2 * pi * ((1:np+1) - 1)/ np) ;
            plot( real(z), imag( z ) ) ;
         end

         if ( withPreconditioning )
            savePlot( f, sprintf( 'gershgorinPlotPreconditionedR%dFig%d.%s', r, fignum, fileExtension ) ) ;
         else
            savePlot( f, sprintf( 'gershgorinPlotR%dFig%d.%s', r, fignum, fileExtension ) ) ;
         end
      end
   else
      [t, stats, residuals] = conjugateGradientQuarteroniPrecond( G, b, P, 1e-3 ) ;
      x = [1:size(residuals, 2)] ;

      f = figure ;
%      if ( 0.1 == r )
         plot( x, log10(residuals), '.-' ) ;
         ylabel( 'log_{10}(residual)' ) ;
         legend( sprintf('R = %2.1f', r) ) ;
%      else
%         plot( x, residuals ) ;
%         ylabel( sprintf('residual, R = %2.1f', r) ) ;
%      end

      xlabel( 'iteration' ) ;

      savePlot( f, sprintf( 'residualsByIterationR%2.1fFig%d.%s', r, fignum, fileExtension ) ) ;
   end

   fignum = fignum + 1 ;
end
