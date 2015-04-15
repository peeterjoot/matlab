
% for question posted to stackoverflow:
%
% http://stackoverflow.com/questions/29607685/how-to-numerically-search-for-all-closest-to-zero-values-in-an-matlab-array

    a = [ 0.0062 ; 0.0041 ; 0.0021 ; 0.0003 ; 0.0015 ; 0.0031 ; 0.0045 ; 0.0059 ; 0.0062 ; 0.0041 ; 0.0021 ; 0.0003 ; 0.0015 ; 0.0031 ; 0.0045 ; 0.0059 ]/0.0062 ;
    d = diff(a) ;
    
    r = -3/2:0.5:length(a)/2-4/2 ;
    
    close all ;
    hold on ;
    
    plot( r, a ) ;
    plot( r(1:length(d)), d ) ;
    plot( r(1:length(d)), sign(d) ) ;
