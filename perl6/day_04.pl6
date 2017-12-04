#! /usr/bin/env perl6

# This is a Perl 6 solution to day four of 2017's Advent of Code; see
# http://adventofcode.com/2017/day/2 for the full puzzle.

sub is_anagram((Str $w1, Str $w2)) {
    $w1.comb.Bag eqv $w2.comb.Bag;
}

sub is_valid_p1(Str $phrase) {
    my $words = $phrase.words;
    $words.elems == $words.Set.elems;
}

sub is_valid_p2(Str $phrase) {
    not so ($phrase.words X $phrase.words)
        .grep(-> ($a, $b) {$a ne $b})
        .map(&is_anagram)
        .any
}

my $lines = 'day_04.input'.IO.lines;
my $part_1_valid = $lines.grep(&is_valid_p1);

say "Part 1: ", $part_1_valid.elems;
say "Part 2: ", $part_1_valid.grep(&is_valid_p2).elems;
