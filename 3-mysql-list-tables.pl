#!/usr/bin/env perl

use strict;
use warnings;

use local::lib 'extlib';

use DBI;
use Config::Simple;

use v5.10;

main();

sub main {

	my $config = Config::Simple->new('extra-files/config.ini');

	my $connection_info = {
		connection => $config->param('db.connection'),
		user => $config->param('db.user'),
		pass => $config->param('db.pass'),
	};
	
	my $db_helper = DBHelper->new($connection_info);
	
	my %databases;
	foreach my $database ($db_helper->find_databases()) {
		my @tables = $db_helper->get_tables_from_database($database);
		$databases{$database} = \@tables;
	}

	foreach my $database (keys %databases) {
		my @tables = @{$databases{$database}};
		say '------';
		if (@tables) {
			say "The database '$database' has the " . @tables . " following tables:";
			foreach my $table (@tables) {
				my $rows = $db_helper->count_rows_of_table($database, $table);
				say "Table '$table' with $rows rows.";  
			}
		} else {
			say "The database '$database' does not have any tables.";
		}
		say "------\n";
	}
}

package DBHelper;

sub new {
	my ($class, $args) = @_;
	my $conn = DBI->connect($args->{connection}, $args->{user}, $args->{pass}) or die $!;
	return bless { conn => $conn }, $class;
}

sub find_databases {
	my $self = shift;

	# my @ignorable_schemas = qw/performance_schema mysql information_schema sys/;
	my @ignorable_schemas = qw/information_schema sys performance_schema/;
	my $placeholders = join ', ', ('?') x @ignorable_schemas;

	my $stmt = $self->{conn}->prepare(qq{
		SELECT
			schema_name 
		FROM
			information_schema.schemata
		WHERE
			schema_name
		NOT
			IN ($placeholders);
	});
	$stmt->execute(@ignorable_schemas);

	my @schemas = map { $_->{schema_name} } @{ $stmt->fetchall_arrayref({}) };
	
	return @schemas;
}

sub get_tables_from_database {
	my ($self, $database) = @_;

	$self->{conn}->do("USE $database;");
	my $stmt = $self->{conn}->prepare("SHOW TABLES;");
	$stmt->execute();
	my @tables = map { $_->[0] } @{$stmt->fetchall_arrayref};
	return @tables;
}

sub count_rows_of_table {
	my ($self, $database, $table) = @_;
	my $stmt = $self->{conn}->prepare("SELECT COUNT(*) as count FROM `$database`.`$table`;");
	$stmt->execute();
	return $stmt->fetchrow_hashref->{count}
}