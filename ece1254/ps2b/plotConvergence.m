function plotConvergence()
   % plotConvergence: docs go here.

   vs = [ 10, 20 ] ;
   fignum = 0 ;
   for V = vs
      fignum = fignum + 1 ;
      ee = 1e-6 ;

      [x, r] = newtonsDiffusion( 100, V, ee, ee, ee, 50, 1, 1 ) ;
      file = sprintf( 'demonstrateQuadraticV%dFig%d', V, fignum ) ;
      [L, m] = quadraticDifferences( x, r.allX(:,2:end-1), file ) ;
   end
end
