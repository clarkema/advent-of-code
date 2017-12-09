#! /usr/bin/env perl6

#use Grammar::Tracer;

class GarbageCounter {
    my $.total = 0;
    method TOP($/) { make $.total }
    method gchar($/) { $.total++; }
}

grammar Stream {
    rule TOP { <group> }
    token group { '{' [ <group> | <.garbage> ]* % \, '}' }
    token garbage { '<' [ <gchar> | <escaped> ]* '>' }
    token escaped { '!' . }
    token gchar { <-[!>]> }
}

sub walk(Match $capture, $depth = 0) {
    my $score = $depth;

    for $capture.caps.grep({$^a.key eq 'group' }) -> Pair $m {
        $score += walk($m.value, $depth + 1);
    }

    $score;
}

my $input = 'day_09.input'.IO.slurp.chomp;
my $match = Stream.parse($input, :actions(GarbageCounter));

say "Part 1: ", walk($match);
say "Part 2: ", $match.made;
