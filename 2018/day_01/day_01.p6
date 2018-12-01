#! perl6

my @drift = "day_01.input".IO.words;

say "Part 1: ", @drift.sum;
say "Part 2: ", ([\+] |@drift xx *).repeated.first;
