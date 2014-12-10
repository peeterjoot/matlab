function partH( plotGershgorinCircles, withPreconditioning )
% collect timing data for each of the part (e) solution methods.
% withPreconditioning: boolean [in].
% plotGershgorinCircles: boolean [in].

N = 20 ;
R = [ 0.1 1 10 ] ;
%R = [ 0.1 ] ;

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
         pInvHalf = inv( sqrt( P ) ) ;

         if ( showSymmetryDebug )
            disp( r ) ;
            disp( max(max(abs(full(G - G.')))) ) ;
            disp( max(max(abs(full(P - P.')))) ) ;
            disp( max(max(abs( pInvHalf - pInvHalf.' ))) ) ;
         end

         G = full( pInvHalf * G * pInvHalf ) ;

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
            saveas( f, sprintf( 'gershgorinPlotPreconditionedR%dFig%d.png', r, fignum ) ) ;
         else
            saveas( f, sprintf( 'gershgorinPlotR%dFig%d.png', r, fignum ) ) ;
         end
      end
   else
      [t, stats, residuals] = conjugateGradientQuarteroniPrecond( G, b, P, 1e-3 ) ;
      x = [1:size(residuals, 2)] ;

      f = figure ;
      plot( x, residuals ) ;
      xlabel( 'iteration' ) ;
      ylabel( sprintf('residual, R = %2.1f', r) ) ;

      saveas( f, sprintf( 'residualsByIterationR%2.1fFig%d.png', r, fignum ) ) ;
   end

   fignum = fignum + 1 ;
end
