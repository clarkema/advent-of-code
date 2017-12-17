#! /usr/bin/env perl6

my $steps = 337;

sub part1() {
    my @buff = [0];
    my $index = 0;

    for 1..2017 -> $i {
        $index = ($index + $steps) % @buff;
        @buff.splice($index + 1, 0, $i);
        $index++;
    }

    say "Part 1: ", @buff[$index + 1];
}


sub part2() {
    my $second = 0;
    my $index = 0;

    for 1..50_000_000 -> $i {
        # If we were actually appending to a buffer, it would have length $i
        # after $i iterations.
        $index = ($index + $steps) % $i; 

        # No need to splice.  If we've landed on 0, just record the element
        # we'd be inserting after it.
        $second = $i if $index == 0;

        $index++;
    }

    say "Part 2: ", $second;
}

part1;
part2;
