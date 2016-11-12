use warnings;
use strict;

print "module Wordlist exposing (..)\n\n";
print "import Dict\n\n";

my $first_match = 1;

while (my $line = <>) {
	if($line =~ /^(\d{5})\s+(.*)$/) {
		my $key = join ",", split //, $1, 5;
		my $val = $2;
		$val = '\"' if $val eq '"';
		if($first_match) {
			$first_match = 0;
			print "wordlist = Dict.fromList [ (($key), \"$val\")\n";
		} else {
			print " , (($key), \"$val\")\n";
		}
	}
}

print " ]\n";
