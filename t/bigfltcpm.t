#!/usr/bin/perl -w

use strict;
use Test::More;

BEGIN 
  {
  $| = 1;
  chdir 't' if -d 't';
  unshift @INC, '../lib'; 	# for running manually
  plan tests => (18+13)*4 + 2*3 + 15 * 2 + 1;
  }

use Math::BigFloat::Constant;

my $x = Math::BigFloat::Constant->new(8);

###########################################################################
# allowed operations

is (ref $x,'Math::BigFloat::Constant', 'ref');

_is ($x,$x,8, 'bstr');
_is ($x,$x+2,10, ' copy add works');
_is ($x,$x->bsstr(), '8e+0', 'bsstr');

_is ($x,$x->is_pos(), 1, 'is_pos');
_is ($x,$x->is_int(), 1, 'is_int');

_is ($x,$x->is_neg(), 0, 'is_neg');
_is ($x,$x->is_one() || 0, 0, 'is_one');
_is ($x,$x->is_nan(), 0, 'is_nan');
_is ($x,$x->is_inf(), 0, 'is_inf');
_is ($x,$x->is_zero() || 0, 0, 'is_zero');

_is ($x,$x->bstr(), '8' , 'bstr');
_is ($x,$x->bsstr(), '8e+0' , 'bsstr');
#_is ($x,$x->digit(0), '8' , 'digit');

_is ($x,$x->as_hex(), '0x8' , 'as_hex');
_is ($x,$x->as_bin(), '0b1000' , 'as_bin');
_is ($x,$x->as_oct(), '010' , 'as_oct');

#my $y = Math::BigFloat::Constant->new(32);
#is ($x->bgcd($y),8, 'gcd');
#$y = Math::BigFloat::Constant->new(53);
#my $z = Math::BigFloat::Constant->new(19);
#is ($x->blcm($y,$z),19*53*8, 'lcm');	

my ($try,$rc);

###########################################################################
# disallowed operation

# unary operations
# 13 * 4
foreach (qw/
        bfloor bceil as_int as_number bfac
	binc bdec bnot bneg babs
        bnan binf bzero
	/)
  {
  is (ref $x,'Math::BigFloat::Constant', 'ref x still ok');
  $@ = ''; $try = "\$x->$_();"; $rc = eval $try; 
  print "# tried: $_()\n" unless is ($x, 8, 'x is 8'); 
  is ($rc, undef, 'undef');
  like ($@, qr/^Can not.*$_/, "$_ died");
  }

# binary operations
# 18*4 tests
foreach (qw/
	badd bsub bmul bdiv bmod
        bxor bior band bpow blsft brsft
	broot bsqrt bexp bnok blog
	bfround bround
	/)
  {
  is (ref $x,'Math::BigFloat::Constant', 'ref x still ok');
  $@ = ''; $try = "\$x->$_(2);"; $rc = eval $try; 
  print "# tried: $_()\n" unless is ($x, 8, 'x is 8'); 
  is ($rc, undef, 'undef');
  like ($@, qr/^Can not.*$_/, "$_ died");
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
  like ($@, qr/^Can not.*$_/, "$_ died");
  }

sub _is
  {
  my ($x,$a,$b,$c) = @_;

  is ($a,$b,$c);
  is (ref $x, 'Math::BigFloat::Constant', 'ref');
  }

1;

