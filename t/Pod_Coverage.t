#!/usr/bin/perl -w

use strict;
use warnings qw(FATAL all);
use lib 'lib';

use Test::More;

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;

all_pod_coverage_ok();
