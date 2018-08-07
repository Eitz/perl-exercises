#!/usr/bin/env perl

use strict;
use warnings;

use v5.10; # for "say"

main('extra-files/numbers.txt');

sub main {
	my $file_name = shift;
	
	my @original_numbers = get_numbers($file_name);
	my @sorted_numbers = sort @original_numbers;
	
	say "Original:   " . join ', ', @original_numbers;
	say "Sorted:     " . join ', ', @sorted_numbers;
}


sub get_numbers {
	
	my $file_name = shift;
	
	open my $fh, '<', $file_name or die "Can't open $file_name: $!";

	my @numbers;
	while (my $number = <$fh>) {
			chomp $number;
			push @numbers, int $number;
	}

	close $fh or die "Can't close $file_name: $!";
	
	return @numbers;
}