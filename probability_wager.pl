my $min = 1;
my $max = 10;

my @possibility = (2, 3, 7);
my @probability = (1,3, 6);

scalar(@possibility) == scalar(@probability) or die("Difference in lengths of probability and possibility arrays");

my $total = 0;
for my $val (@probability) {
	$total += $val;
}

my %dist;
for (0..scalar(@possibility)-1) {
	$dist{$possibility[$_]} = $probability[$_] / $total;
}

print("The distribution:\n");
for (keys %dist) {
	print("$_ -> $dist{$_}\n");
}

my $ev = 0;
for (@possibility) {
	$ev += $_;
}
$ev /= scalar(@possibility);
print("The expected value: $ev\n");

print("\nExpected return for different wagers under different methods:\n");
printf("%5s\t   %-20s\t   %-20s\n", "Wager", "Simple Difference", "Square Difference");

my %simple_diff_ev;
my %square_diff_ev;
my $min_square = 0;
my $min_simple = 0;
for $val ($min..$max) {
	$simple_diff_ev{$val} = findDifference($val, \%dist, 1);
	$square_diff_ev{$val} = findDifference($val, \%dist, 2);
	$min_square = $val if ($square_diff_ev{$val} < $square_diff_ev{$min_square} || $min_square < $min);
	$min_simple = $val if ($simple_diff_ev{$val} < $simple_diff_ev{$min_simple} || $min_simple < $min);
}

print("Largest:\nSquare: $min_square\nSimple: $min_simple\n");

$FORMAT = "%-5s\t%3s%-20.4f\t%3s%-20.4f\n";
for $val ($min..$max) {
	my $is_min_simple = ' ';
	my $is_min_square = ' ';
	
	$is_min_simple = '**' if $val == $min_simple;
	$is_min_square = '**' if $val == $min_square;
	
	
	printf($FORMAT, $val, $is_min_simple,$simple_diff_ev{$val}, $is_min_square,$square_diff_ev{$val});
}





sub findDifference {
	my $val = shift @_;
	my $dist = shift @_;
	my $toPower = shift @_;
	$toPower = 1 unless $toPower > 1;
	
	my $ev = 0;
	
	for my $key (keys %{$dist}) {
		#print("$key -> $dist->{$key} * (abs($key - $val) ** $toPower)" . ($dist->{$key} * (abs($key - $val) ** $toPower)) . " ");
		$ev += $dist->{$key} * (abs($key - $val) ** $toPower);
		#print("$ev\n");
	}
	
	return $ev;
}
