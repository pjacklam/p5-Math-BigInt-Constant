#!/usr/bin/perl -w

use strict;
use Test::More;

BEGIN 
  {
  $| = 1;
  chdir 't' if -d 't';
  unshift @INC, '../lib'; 	# for running manually
  plan tests => 26*4 + 2*3 + 19;
  }

use Math::BigInt::Constant;

my $x = Math::BigInt::Constant->new(8);

###########################################################################
# allowed operations

is (ref $x,'Math::BigInt::Constant', 'ref');
is ($x,8, 'new');
is ($x+2,10, ' copy add works');

is ($x->bfloor(),8, 'floor');
is ($x->bceil(),8 , 'ceil');

is ($x->as_int(), 8 , 'as_int');
is ($x->as_number(), 8 , 'as_number');

is ($x->is_pos(), 1, 'is_pos');
is ($x->is_int(), 1, 'is_int');

is ($x->is_neg(), 0, 'is_neg');
is ($x->is_one(), 0, 'is_one');
is ($x->is_nan(), 0, 'is_nan');
is ($x->is_inf(), 0, 'is_inf');
is ($x->is_zero(), 0, 'is_zero');

is ($x->bstr(), '8' , 'bstr');
is ($x->bsstr(), '8e+0' , 'bsstr');
is ($x->digit(0), '8' , 'digit');

my $y = Math::BigInt::Constant->new(32);
is ($x->bgcd($y),8, 'gcd');
$y = Math::BigInt::Constant->new(53);
my $z = Math::BigInt::Constant->new(19);
is ($x->blcm($y,$z),19*53*8, 'lcm');	
my ($try,$rc);

###########################################################################
# disallowed operation

# binary operations
# 26*3 tests
foreach (qw/
	badd bsub bmul bdiv bmod  binc  bdec  bnot bneg babs
        bxor bior band bpow blsft brsft
        bnan binf bzero
	bfac broot bsqrt bfac blog
	bfround bround
	/)
  {
  is (ref $x,'Math::BigInt::Constant', 'ref x still ok');
  $@ = ''; $try = "\$x->$_(2);"; $rc = eval $try; 
  print "# tried: $_()\n" unless is ($x, 8, 'x is 8'); 
  is ($rc, undef, 'undef');
  like ($@, qr/^Can not/, "$_ died");
  }
        
# ternary operations
# 2*3 tests
foreach (qw/
	bmodpow bmodinv
	/ )
  {
  $@ = ''; $try = "\$x->$_(2,3);"; $rc = eval $try; 
  print "# tried: $_()\n" unless is ($x,8, 'x is 8'); 
  is ($rc, undef, 'undef');
  like ($@, qr/^Can not/, "$_ died");
  }

1;

