function setFigureProperties( s, fontSize, width, height )
   % setFigureProperties: 
   % Example how to adjust your figure properties for
   % publication needs
   % parameters: 
   %   s: figure handle
   %   fontSize: default 16.
   %   width: in cm
   %   height: in cm

   if ( nargin < 2 )
      fontSize = 16 ;
   end
   if ( nargin < 3 )
      width = 12 ;
   end
   if ( nargin < 3 )
      height = 10 ;
   end

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
