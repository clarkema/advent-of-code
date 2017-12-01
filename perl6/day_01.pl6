#! /usr/bin/env perl6

# This is a Perl 6 solution to day one of 2017's Advent of Code; see
# http://adventofcode.com/2017/day/1 for the full puzzle.

sub captcha_sum($digits, $rotation) {
    my @d = $digits.comb;

    (@d Z @d.rotate($rotation))
        .grep({ [==] $_ })
        .map({.first})
        .sum
}


my $input = 'day_01.input'.IO.slurp.chomp;
say "Part 1: ", captcha_sum($input, 1);
say "Part 2: ", captcha_sum($input, $input.chars/2);
