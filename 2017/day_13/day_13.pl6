#! /usr/bin/env perl6

class Layer {
    has $.scanner = 0;
    has $.range = 0;
    has $!direction = 1;

    method Str {
        do for ^$!range {
            $^i == $!scanner ?? "[S]" !! "[ ]";
        }.join("")
    }

    method tick {
        if ($!direction ==  1 && $!scanner == $!range - 1) or
           ($!direction == -1 && $!scanner == 0)
        {
            $!direction = -$!direction;
        }

        $!scanner += $!direction;
    }
}

class Firewall {
    has @.layers = [];

    method Str {
        @!layers.map(-> $l {
            given $l {
                when Layer { $l.Str }
                when Any { "" }
            }
        }).join("\n");
    }

    method new-layer(Int $depth, Int $range) {
        @!layers[$depth] = Layer.new(:$range);
    }

    method tick {
        for @!layers -> $l {
            next unless $l;
            $l.tick;
        }
    }
}

my $f = Firewall.new();

for 'day_13.input'.IO.lines -> $line {
    my ($depth, $range) = $line.comb(/\d+/);
    $f.new-layer($depth.Int, $range.Int);
}

my $cost = 0;

for ^$f.layers.elems -> $i {
    my $layer = $f.layers[$i];

    if $layer {
        if $layer.scanner == 0 {
            $cost += ($i * $layer.range)
        }
    }

    $f.tick;
}

say $cost;

# Brute-force clean path

DELAY:
for ^Inf -> $delay {
    for ^$f.layers.elems -> $i {
        if $f.layers[$i] and ($delay + $i) %% (2 * $f.layers[$i].range - 2) {
            next DELAY;
        }
    }
    say "Got $delay";
    exit;
}
