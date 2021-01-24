#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;
use Stitch::Compute;

my $HTML;
{
    local $/ = undef;
    $HTML = <DATA>;
}

my $app = sub {
    my ($env) = @_;
    
    my $request = Plack::Request->new($env);
    my $from = $request->param('from') || 0;
    my $to   = $request->param('to')   || 0;

    my $answer = '';

    if ($from > 0 and $to > 0) {
	$answer = "from $from to $to:<br>" . Stitch::Compute::adjust_stitches($from, $to);
    }
    else {
	$answer = '';
    }
    
    my $response = $HTML;
    $response =~ s/%%OUTPUT%%/$answer/;
    
    return [
	'200',
	[ 'Content-Type' => 'text/html' ],
	[ $response ],
	];
};


__DATA__
<html>
<body>
<h1>stitch compute</h1>
<form method="post">
<label>From: </label><input type="number" name="from" min="1" max="512" required><br>
<label>To: </label><input type="number" name="to" min="1" max="512" required><br>
<input type="submit" value="submit">
</form>
<p>%%OUTPUT%%</p>
</body>
</html>
