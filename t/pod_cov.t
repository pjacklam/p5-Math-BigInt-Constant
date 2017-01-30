#!/usr/bin/perl -w

use Test::More;
use strict;

my $tests;

BEGIN
   {
   $tests = 2;
   plan tests => $tests;
   chdir 't' if -d 't';
   use lib '../lib';
   };

SKIP:
  {
  skip("Test::Pod::Coverage 1.08 required for testing POD coverage", $tests)
    unless do {
    eval "use Test::Pod::Coverage 1.08";
    $@ ? 0 : 1;
    };

  my $trustme = { 
    trustme => [ qw/copy modify/ ], 
    };
  pod_coverage_ok( 'Math::BigInt::Constant', $trustme, "All our Math::BigInts are covered" );
  $trustme = { 
    trustme => [ qw/copy modify as_int/ ], 
    };
  pod_coverage_ok( 'Math::BigFloat::Constant', $trustme, "All our Math::BigFloats are covered" );
  }
