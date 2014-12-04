#!/usr/bin/perl

# reformat matlab double format stuff like 1.0e-06 in latex math mode format.

while (<>)
{
   chomp ;

   s/(\d\.\d)e(.)(\d+)/formatexp($1, $2, $3)/ge ;

   print "$_\n" ;
}

exit 0 ;

sub formatexp
{
   my ( $digits, $s, $e ) = @_ ;

   if ( $e =~ /^0+$/ )
   {
      return $digits ;
   }
   else
   {
      $e =~ s/^0+// ;
      $s =~ s/\+// ;

      return "\\( $digits \\times 10^{$s$e} \\)" ;
   }
}
