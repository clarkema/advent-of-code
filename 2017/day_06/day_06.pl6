#!/usr/bin/env perl6

my @mem = 'day_06.input'.IO.slurp.comb(/\d+/).map: *.Int;

my %seen = %();

my $cycle = 0;
while not %seen{@mem.perl} {
    %seen{@mem.perl} = $cycle++;

    my $max = 0 => 0;
    $max = .clone if .value > $max.value for @mem.pairs;

    @mem[$max.key] = 0;
    my $i = $max.key;
    @mem[++$i % @mem]++ for ^$max.value;
}

say "Seen before: ", $cycle;
say "Loop size: ", $cycle - %seen{@mem.perl};
