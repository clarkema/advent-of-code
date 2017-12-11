#! /usr/bin/env perl6

# See https://www.redblobgames.com/grids/hexagons/ for a fantastic
# introduction to tiled hex cubes on the Cartesian plane, and the
# background to the Cube structure below.

class Cube {
    my $O  = Cube.new(:x(0),  :y(0),  :z(0));
    my $N  = Cube.new(:x(0),  :y(1),  :z(-1));
    my $NE = Cube.new(:x(1),  :y(0),  :z(-1));
    my $NW = Cube.new(:x(-1), :y(1),  :z(0));
    my $S  = Cube.new(:x(0),  :y(-1), :z(1));
    my $SE = Cube.new(:x(1),  :y(-1), :z(0));
    my $SW = Cube.new(:x(-1), :y(0),  :z(1));

    submethod ORIGIN { $O };
    submethod N      { $N };
    submethod NE     { $NE };
    submethod NW     { $NW };
    submethod S      { $S };
    submethod SE     { $SE };
    submethod SW     { $SW };

    has $.x = 0;
    has $.y = 0;
    has $.z = 0;

    method distance(Cube $other) {
        ((abs self.x - $other.x) +
         (abs self.y - $other.y) +
         (abs self.z - $other.z)) / 2
    }
}

multi sub infix:<+>(Cube $lhs, Cube $rhs) {
    Cube.new(
        x => $lhs.x + $rhs.x,
        y => $lhs.y + $rhs.y,
        z => $lhs.z + $rhs.z,
    );
}

my @moves = 'day_11.input'.IO.slurp.comb(/<[ns]><[ew]>?/).map(&uc);

# This works if we just care about the final distance
say "Part 1: ",
    @moves.map({Cube."$^m"()})
        .reduce(* + *)
        .distance(Cube.ORIGIN);

# Part 2 duplicates the work for part 1; we could drop the part 1
# calculations, but it's interesting to compare the difference.
my Cube $current = Cube.ORIGIN;
my $max_distance = 0;

for @moves -> $m {
    $current += Cube."$m"();
    $max_distance max= $current.distance(Cube.ORIGIN);
}

say "Part 2: ", $max_distance;
