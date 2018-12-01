#! perl -wl

use strict;
use File::Slurp;
use List::Util qw/sum/;

my @drifts = read_file("day_01.input");

sub part_2 {
    my %seen;
    my $acc = 0;
    for (;;) {
        for (@drifts) {
            $acc += $_;
            return $acc if $seen{$acc}++;
        }
    }
}
print "Part 1: ", sum(@drifts);
print "Part 2: ", part_2;
