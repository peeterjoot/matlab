clear all ;

enableDebug() ;

epsilon = eps(1.0) * 100 ;

% requires no pivots:
A = [2 0 4 ;
     1 1 1 ;
     0 0 1 ] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L *U) ~= zeros(3) )
   disp( A ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc1', 'A != L * U' ) ;
end

% also requires no pivots
A = [2 2 0 0 ;
     0 1 2 1 ;
     1 2 1 1 ;
     0 1 1 0 ] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L *U) ~= zeros(4) )
   disp( A ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc2', 'A != L * U' ) ;
end

% requires pivots
A = [2 2 0 0 ;
     0 1 2 1 ;
     1 2 1 1 ;
     0 1 2 2 ] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L *U) ~= zeros(4) )
   disp( P ) ;
   disp( A ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc3', 'A != L * U' ) ;
end

% requires pivots:
A = [
     2     2     0     0 ;
     0     1     2     1 ;
     0     1     2     2 ;
     1     2     1     1 ;
] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L *U) ~= zeros(4) )
   disp( P ) ;
   disp( A ) ;
   disp( L ) ;
   disp( U ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc3.1', 'A != L * U' ) ;
end

% requires two pivots:
A = [0 0 1 ;
     2 0 4 ;
     1 1 1 ] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L * U) ~= zeros(3) )
   disp( P ) ;
   disp( A ) ;
   disp( L ) ;
   disp( U ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc4', 'P A != L * U' ) ;
end

A = [1 1 1 ;
     2 3 1 ;
     3 2 1 ] ;
[P, L, U, s] = withPivotLU( A, epsilon ) ;
if ( A - (L * U) ~= zeros(3) )
   disp( P ) ;
   disp( A ) ;
   disp( L ) ;
   disp( U ) ;
   disp( L * U ) ;
   error( 'withPivotLU:tc4', 'P A != L * U' ) ;
end

% t/c to trigger size checking error:
A = [2 3 1 ;
     3 2 1 ] ;
[P, L, U, s] = withPivotLU( A ) ;

