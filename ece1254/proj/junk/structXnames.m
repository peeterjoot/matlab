% http://stackoverflow.com/questions/27367535/matlab-struct-type-looses-type-of-cell-array-field
function r = foo()
    xnames = cell( 3, 1 ) ;
    for i = [1:3]
       xnames{i} = sprintf( 'V_%d', i ) ;
    end
 
    a = 1 ;
    b = 2 ;
    if ( 0 )
       r = struct( 'a', a, 'b', b, 'x', { xnames } ) ;
    
       r.x{1}
       r.x{2}
       r.x{3}
    else
       r = struct( 'a', a, 'b', b ) ;
       r.x = xnames ;
    
       r.x{1}
       r.x{2}
       r.x{3}
    end
end
