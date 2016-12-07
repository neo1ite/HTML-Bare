#!/usr/bin/perl -w

use strict;
use warnings qw(FATAL all);
use lib 'lib';
use Test::More qw(no_plan);

use_ok('HTML::Bare', qw/htmlin/);

my $xml;
my $root;
my $simple;

($xml, $root, $simple) = reparse('<html><head>head</head><body>body</body></html>');
is($root->{html}->{head}->{value}, 'head', 'normal head value reading');
is($simple->{head},                'head',  'simple - normal head value reading');

is($root->{html}->{body}->{value}, 'body', 'normal body value reading');
is($simple->{body},                'body',  'simple - normal body value reading');

($xml, $root, $simple) = reparse('<html><head><script type="text/javascript" src="https://www.example.com/js/jquery.js" /></head><body></body></html>');
is($root->{html}{head}{script}{type}{value}, 'text/javascript', "reading of value of standalone attribute");
is($simple->{head}{script}{type},            'text/javascript', "simple - reading of value of standalone attribute");

is($root->{html}{head}{script}{src}{value}, 'https://www.example.com/js/jquery.js', "reading of value of standalone attribute");
is($simple->{head}{script}{src},            'https://www.example.com/js/jquery.js', "simple - reading of value of standalone attribute");

($xml, $root, $simple) = reparse('<html><head><script type="text/javascript"></script></head><body></body></html>');
is($root->{html}{head}{script}{type}{value}, 'text/javascript', "reading of value of standalone attribute");
is($simple->{head}{script}{type},            'text/javascript', "simple - reading of value of standalone attribute");

($xml, $root, $simple) = reparse(q~<html><head><script type="text/javascript">
    $(function () {
        var $token = $("meta[name='_csrf']");
        var $header = $("meta[name='_csrf_header']");
        if($token.length == 0 || $header.length == 0) {
            console.log("CSRF metadata was not found");
        } else {
            var token = $token.attr("content");
            var header = $header.attr("content");
            $(document).ajaxSend(function (e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });
        }
    });
</script></head><body></body></html>~);
ok($root->{html}{head}{script}{value}, "Got some script" );

($xml, $root, $simple) = reparse('<html><head><script type="text/javascript">/* script comment */</script></head><body></body></html>');
is($root->{html}{head}{script}{value}, '/* script comment */', "reading of value of standalone attribute");
is($simple->{head}{script}{content},            '/* script comment */', "simple - reading of value of standalone attribute");

($xml, $root, $simple) = reparse('<html><head><script type="text/javascript">/* another script comment */</script></head><body></body></html>');
is($root->{html}{head}{script}{value}, '/* another script comment */', "reading of value of standalone attribute");
is($simple->{head}{script}{content},            '/* another script comment */', "simple - reading of value of standalone attribute");

sub reparse {
  my $text   = shift;
  my $nosimp = shift;

  my ($xml, $root) = HTML::Bare->new(text => $text);
  my $a = $xml->html($root);

  ($xml, $root) = HTML::Bare->new(text => $a);
  my $simple = $nosimp ? 0 : htmlin( $text );

  return ( $xml, $root, $simple );
}
