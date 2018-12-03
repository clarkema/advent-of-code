#! perl6

class Point {
    has Int $.x;
    has Int $.y;
}

class Rect {
    has Int $.id;
    has Point $.upper;
    has Point $.lower;

    method overlap-p(Rect $other) {
        not ((self.upper.x > $other.lower.x) or
        (self.lower.x < $other.upper.x) or
        (self.lower.y < $other.upper.y) or
        (self.upper.y > $other.lower.y));
    }
}

my $claim = rx{
    ^\#$<id>=(\d+) <.ws>
    '@' <.ws>
    $<left>=(\d+)\,$<top>=(\d+)\: <.ws>
    $<width>=(\d+)x$<height>=(\d+)$
};

my @fabric;
my @rects;

for "day_03.input".IO.lines -> $line {
    my $box = $line ~~ $claim;
    my $r = Rect.new(id => $box<id>.Int,
                     upper => Point.new(x => $box<left>.Int,
                                        y => $box<top>.Int),
                     lower => Point.new(x => $box<left> + $box<width> - 1,
                                        y => $box<top> + $box<height> - 1));

    @rects.push: $r;
    for $box<top>..($box<top>+$box<height> - 1) -> $row {
        for $box<left>..($box<left>+$box<width> - 1) -> $col {
            @fabric[$row;$col]++;
        }
    }
}

my $multi;

for @fabric -> $row {
    next unless $row ~~ Positional;
    $multi += $row.grep({ $^a.defined and $^a > 1 }).elems;
}

say "Part 1: $multi";

CAND: for @rects -> $candidate {
    for @rects -> $other {
        next if $other === $candidate;
        next CAND if $candidate.overlap-p: $other ;
    }

    # If we're here there were no overlaps;
    say "Part 2: {$candidate.id}";

    exit;
}
