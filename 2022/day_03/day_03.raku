#! /usr/bin/env raku

sub priority(Str:D $c) {
    given $c {
        when /^<lower>$/ { $c.ord - 96 }
        when /^<upper>$/ { $c.ord - 38 } 
        default { die }
    }
}
my @lines = "day_03.input".IO.lines;

say "Part 1: ", @lines.map( -> $line {
    my @comps = $line.comb(Int($line.chars / 2));
    @comps>>.comb>>.Set.reduce( * ∩ * ).keys.first.&priority;
}).sum;

say "Part 2: ", @lines.batch(3).map( -> @group {
    @group>>.comb>>.Set.reduce( * ∩ * ).keys.first.&priority;
}).sum;
