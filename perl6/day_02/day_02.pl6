#! /usr/bin/env perl6

# This is a Perl 6 solution to day two of 2017's Advent of Code; see
# http://adventofcode.com/2017/day/2 for the full puzzle.

sub checksum_a(Str:D $ssheet, --> Int) {
    sum map {
        # Got to cast to Int here or min and max do a lexical comparison
        my @d = .comb(/\d+/).map(*.Int);
        @d.max - @d.min;
    }, $ssheet.lines
}

sub checksum_b(Str:D $ssheet, --> Int) {
    sum map {
        my @d = .comb(/\d+/).map(*.Int);
        (@d X @d)
            .grep(-> ($a, $b) { $a != $b && $a %% $b })
            .map({.[0] div .[1]})
            .first;
    }, $ssheet.lines
}

my $input = 'day_02.input'.IO.slurp.chomp;
