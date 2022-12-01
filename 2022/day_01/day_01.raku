#! /usr/bin/env raku

my @elves = "day_01.input".IO.split("\n\n");
my @cals_per_elf = @elves.map({ .split("\n").sum }).sort.reverse;

say "Part 1: ", @cals_per_elf[0];
say "Part 2: ", @cals_per_elf[0..2].sum;
