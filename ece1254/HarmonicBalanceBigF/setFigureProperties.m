function setFigureProperties( s, fontSize, width, height, lineWidth )
   % setFigureProperties: 
   % Example how to adjust your figure properties for
   % publication needs
   % parameters: 
   %   s: figure handle
   %   fontSize: default 18.
   %   width: in cm
   %   height: in cm

   if ( nargin < 2 )
      fontSize = 18 ;
   end
   if ( nargin < 3 )
      width = 12 ;
   end
   if ( nargin < 4 )
      height = 10 ;
   end
   if ( nargin < 5 )
      lineWidth = 4 ;
   end

   if ( 0 )
      % based on:
      % http://www.zhinst.com/blogs/schwizer/2010/11/plots-for-scientific-publications/

      % Select the default font and font size
      % Note: Matlab does internally round the font size
      % to decimal pt values
      set(s, 'DefaultTextFontSize', fontSize); % [pt]
      set(s, 'DefaultAxesFontSize', fontSize); % [pt]
      set(s, 'DefaultAxesFontName', 'Times New Roman');
      set(s, 'DefaultTextFontName', 'Times New Roman');
      % Select the preferred unit like inches, centimeters,
      % or pixels
      set(s, 'Units', 'centimeters');
      pos = get(s, 'Position');
      pos(3) = width; % Select the width of the figure in [cm]
      pos(4) = height; % Select the height of the figure in [cm]
      set(s, 'Position', pos);
      set(s, 'PaperType', 'a4letter');
      % From SVG 1.1. Specification:
      % "1pt" equals "1.25px"
      % "1pc" equals "15px"
      % "1mm" would be "3.543307px"
      % "1cm" equals "35.43307px"
      % "1in" equals "90px"
   end

   % not useful if using export_fig().
   if ( 0 )
      % http://dgleich.github.io/hq-matlab-figs/#1
      %
      % Creating high-quality graphics in MATLAB for papers and presentations
      %
      pos = get( s, 'Position' ) ;

      % Set size
      set( s, 'Position', [pos(1) pos(2) width*100, height*100] ) ;

      % Set properties
      set( gca, 'FontSize', fontSize, 'LineWidth', lineWidth ) ;
   end

   % eliminate the background that makes the saved plot look like the GUI display window background color:
   set( s, 'Color', 'w' ) ;
end
