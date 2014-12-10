clear all ;
e = eps(1.0) ;
epsilon = eps(1.0) * 100 ;

U = [ 2     0     4 ;
      0     1    -1 ;
      0     0     1 ] ;

verifyUpperTriangular( U, epsilon )

U = [ 2     0     4 ;
      0     1    -1 ;
      e     0     1 ] ;

verifyUpperTriangular( U, epsilon )

% should fail:
verifyUpperTriangular( U.', epsilon )

% should fail:

U = [ 2     0     4 ;
      0     1    -1 ;
      e*1000     0     1 ] ;

verifyUpperTriangular( U, epsilon )
