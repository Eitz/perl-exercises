#!/usr/bin/env perl

use strict;
use warnings;

use v5.10; # for "say"

my $parameter = $ARGV[0];

if ($parameter) {
	say $parameter;
} else {
	say "[ERROR] No parameter provided. Usage: perl $0 PARAMETER";
	exit 1;
}
