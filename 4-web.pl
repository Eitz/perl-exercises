#!/usr/bin/env perl

use local::lib 'extlib';

use Mojolicious::Lite;

use constant {
	PORT => 3000
};

get '/' => sub {
	my $c = shift;
	return $c->render('index');
};

get '/random-numbers' => sub {
	my $c = shift;

	my $random_numbers = [
		get_random_number(1, 31),
		get_random_number(1, 12),
		get_random_number(1990, 2018),
		get_random_number(0, 23),
		get_random_number(0, 59),
	];

	$c->render(json => {
		numbers => $random_numbers
	});
};

sub get_random_number {
	my ($min, $max) = @_;
	return $min + int rand($max - $min);
}

app->start('daemon', '-l', 'http://*:' . PORT);

__DATA__

@@ index.html.ep

<!doctype HTML>
<html>
	<head>
		<title>Test 4</title>
		<style>
			body, table {
				text-align: center;
				font-size: 16px;
			}
			table {
				margin: 20px auto;
			}
			table,th,td {
				border: 1px solid #AAA;
			}
		</style>
	<body>
		
		<button id="randomButtonAdder">
			Click me to add random dates
		</button>
		
		<table id="randomNumbersTable" border=0>
			<tr>
				<th>Day</th>
				<th>Month</th>
				<th>Year</th>
				<th>Hour</th>
				<th>Minute</th>
			</tr>
		</table>
			
		<script>

			document.getElementById('randomButtonAdder').onclick = getNumbers;

			function getNumbers() {
				var xhr = new XMLHttpRequest();
				xhr.open('GET', '/random-numbers');
				xhr.onload = function() {
					if (xhr.status === 200) {
						let response = JSON.parse(xhr.responseText);
						addRow(response.numbers);
					} else {
						alert('Server is down?');
					}
				};
				xhr.send();
			}
			function addRow(numbers) {
				let table = document.getElementById('randomNumbersTable');
				let tr = document.createElement('tr');
				for (let number of numbers) {
					let td = document.createElement('td');
					td.appendChild(document.createTextNode(number));
					tr.appendChild(td);
				}
				table.appendChild(tr);
			}
		</script>
	</body>
</html>
