#!/usr/bin/env perl6

use Memoize;

class Point {
    has Int $.x;
    has Int $.y;

    method new(Int $x, Int $y) {
        self.bless(:$x, :$y);
    }

    method Str {
        "P($.x, $.y)"
    }

    method neighbours {
        gather {
            for -1..1 -> $i {
                for -1..1 -> $j {
                    next if $i == 0 && $j == 0;
                    take Point.new(self.x + $i, self.y + $j);
                }
            }
        }
    }
}

sub index-to-coords(Int $n, --> Point) {
    my $k = ceiling((sqrt($n) - 1) / 2);
    my $t = 2 * $k + 1;
    my $m = $t ** 2;
    $t -= 1;

    if $n >= $m - $t { return Point.new($k-($m-$n),-$k) } else { $m=$m-$t }; 
    if $n >= $m - $t { return Point.new(-$k,-$k+($m-$n)) } else { $m=$m-$t };
    if $n >= $m - $t { return Point.new(-$k+($m-$n),$k) } else { return Point.new($k,$k-($m-$n-$t)) };
}

sub difference(Point $a, Point $b) {
    if $a.y == $b.y {
        abs($a.x - $b.x);
    } else {
        abs($a.y - $b.y);
    }
}

sub nearest-diag(Point $p) {
    if $p.y > 0 && $p.x >= 1 - $p.y && $p.x <= $p.y {
        # Top row
        %( point => Point.new($p.y, $p.y),
           side  => 'tr',
           :diffop(&infix:<+>));
    } elsif $p.y <= 0 && $p.x >= $p.y and $p.x <= -$p.y {
        # Bottom row
        %( point => Point.new($p.y, $p.y),
           side  => 'bl',
           :diffop(&infix:<+>));
    } elsif $p.x < 0 {
        # Left column
        %( point => Point.new($p.x, $p.x),
           side  => 'bl',
           :diffop(&infix:<->));
    } else {
        # Right column
        %( point => Point.new($p.x, $p.x),
           side  => 'tr',
           :diffop(&infix:<->));
    }
}

sub coords-to-index(Point $coords) {
    my %nearest = nearest-diag($coords);
    my Point $diag = %nearest<point>;
    my $side = %nearest<side>;
    my &diffop = %nearest<diffop>;

    my $x = abs($diag.x);
    my $diag_index = $side ~~ 'tr'
                        ?? (4 * $x**2) - 2 * $x + 1
                        !! (4 * $x**2) + 2 * $x + 1;


    #say "Point: $coords.  Nearest diagonal is $diag with index $diag_index";

    my $diff = difference($coords, $diag);
    #say "Diff: $diff";
    #say "Point index ", &diffop($diag_index, $diff);
    &diffop($diag_index, $diff);
}

sub index-value(Int $index, --> Int) is memoized {
    return 1 if $index == 1;
    my Point $p = index-to-coords($index);

    my $value = $p.neighbours
        .map(&coords-to-index)
        .grep({ $^a < $index })
        .map(&index-value)
        .sum
}
sub steps(Point $p) {
    ($p.x, $p.y).map(*.abs).sum
}


say "Part 1: ", steps(index-to-coords(347991));

say "Part 2: ", (1..*).map({ $^a, index-value($^a)}).grep({$^i[1] > 347991}).first;
