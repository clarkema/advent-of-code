#! /usr/bin/env perl6

#use Grammar::Tracer;

class StreamStats {
    has $!depth = 0;
    has $.garbage-count = 0;
    has $.total-score = 0;
    method gchar($/) { $!garbage-count++; }
    method group-start($/) { $!depth++ }
    method group-end($/) { $!total-score += $!depth-- }
}

grammar Stream {
    rule TOP { <group> }
    token group {
        <group-start> [ <group> | <.garbage> ]* % \, <group-end>
    }
    token group-start { '{' }
    token group-end   { '}' }
    token garbage     { '<' [ <gchar> | <escaped> ]* '>' }
    token escaped     { '!' . }
    token gchar       { <-[!>]> }
}

my $input = 'day_09.input'.IO.slurp.chomp;
my $stats = StreamStats.new;
my $match = Stream.parse($input, :actions($stats));

say "Part 1: ", $stats.total-score;
say "Part 2: ", $stats.garbage-count;
