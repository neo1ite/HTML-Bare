#!/usr/bin/perl -w

use strict;
use warnings qw(FATAL all);
use lib 'lib';
use Test::More qw(no_plan);

use_ok( 'HTML::Bare', qw/htmlin/ );

my ($ob1, $root1) = HTML::Bare->simple(text => '<html><head><script type="text/javascript">/*replacing <i> for robots to <a> for users*/</script></head><body></body></html>');
ok($root1,        "Got some root");
my $script_content1 = $root1->{'html'}{'head'}{'script'}{'content'};
is($script_content1, '/*replacing <i> for robots to <a> for users*/', "Got the right script comment value");

my ($ob2, $root2) = HTML::Bare->simple(text => '<html><head><script type="text/javascript">/*replacing </i> for robots to </a> for users*/</script></head><body></body></html>');
ok($root2,        "Got some root");
my $script_content2 = $root2->{'html'}{'head'}{'script'}{'content'};
is($script_content2, '/*replacing </i> for robots to </a> for users*/', "Got the right script comment value");

my ($ob3, $root3) = HTML::Bare->simple(text => '<html><head><script type="text/javascript">/*replacing </strong> for robots to <a> for users*/</script></head><body></body></html>');
ok($root3,        "Got some root");
my $script_content3 = $root3->{'html'}{'head'}{'script'}{'content'};
is($script_content3, '/*replacing </strong> for robots to <a> for users*/', "Got the right script comment value");

my ($ob4, $root4) = HTML::Bare->simple(text => '<html><head><script type="text/javascript">/*replacing <span> for robots to </a> for users*/</script></head><body></body></html>');
ok($root4,        "Got some root");
my $script_content4 = $root4->{'html'}{'head'}{'script'}{'content'};
is($script_content4, '/*replacing <span> for robots to </a> for users*/', "Got the right script comment value");

my ($ob5, $root5) = HTML::Bare->simple(text => '<html><head><script type="text/javascript">/*replacing <h4> for robots to </h4> for users*/</script></head><body></body></html>');
ok($root5,        "Got some root");
my $script_content5 = $root5->{'html'}{'head'}{'script'}{'content'};
is($script_content5, '/*replacing <h4> for robots to </h4> for users*/', "Got the right script comment value");

#my $sub_val = $root->{'node'}{'sub'};
#is($sub_val, '', "Got the right sub value");
