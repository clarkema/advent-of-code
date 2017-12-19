#! /usr/bin/env perl6

enum Direction <NORTH SOUTH EAST WEST>;

multi sub prefix:<->(Direction $d) {
    given $d {
        when NORTH { SOUTH }
        when SOUTH { NORTH }
        when EAST  { WEST }
        when WEST  { EAST }
    }
}

class Point {
    my $N = Point.new(:x(0), :y(-1));
    my $S = Point.new(:x(0), :y(1));
    my $E = Point.new(:x(1), :y(0));
    my $W = Point.new(:x(-1), :y(0));

    has Int $.x;
    has Int $.y;

    method Str {
        "P($.x, $.y)"
    }

    submethod NORTH { $N };
    submethod SOUTH { $S };
    submethod EAST  { $E };
    submethod WEST  { $W };
}

multi sub infix:<+>(Point $lhs, Point $rhs) {
    Point.new(
        x => $lhs.x + $rhs.x,
        y => $lhs.y + $rhs.y,
    )
}

multi sub postcircumfix:<[ ]>(@cont, Point $point) {
    @cont[$point.y][$point.x];
}

# The starting point is the only place on the top row with a character
# (simplifying for puzzle input)
sub starting-point(@maze) {
    my $col = @maze[0].grep("|", :k).first;
    Point.new(:x($col), :y(0));
}

my @trail;
my $steps = 0;

sub move(@maze, $pos, $dot) {
    # Get the next point we would move into if we keep going
    my $next = $pos + Point."$dot"();
    my $direction = $dot;

    $steps++;
    @trail.push(@maze[$pos]) if @maze[$pos] ~~ /<[A..Z]>/;

    given @maze[$next] {
        when /\s/ {
            # Need to turn
            for Direction::.values (-) Set($dot, -$dot) -> $pair {
                my $option = $pair.key;
                if @maze[ $pos + Point."$option"() ] ~~ /\S/ {
                    $next = $pos + Point."$option"();
                    $direction = $option;
                    proceed;
                }
            }

            return "FINISHED";
        }

    }
    move(@maze, $next, $direction);
}

my @maze = 'day_19.input'.IO.lines.map(*.comb('').Array).Array;

move(@maze, starting-point(@maze), SOUTH);

say "Part 1: ", @trail.join('');
say "Part 2: ", $steps;
