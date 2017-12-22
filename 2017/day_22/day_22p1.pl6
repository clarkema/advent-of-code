#! /usr/bin/env perl6

enum Direction (
    NORTH => ( 0, -1),
    SOUTH => ( 0,  1),
    EAST  => ( 1,  0),
    WEST  => (-1,  0),
);

my %grid;
my $current-node = (0, 0);
my $facing = NORTH;
my $infected = 0;

multi turn(Direction $d, :$cw) {
    do given $d {
        when NORTH { EAST }
        when EAST { SOUTH }
        when SOUTH { WEST }
        when WEST { NORTH }
    }
}

multi turn(Direction $d, :$ccw) {
    do given $d {
        when NORTH { WEST }
        when WEST { SOUTH }
        when SOUTH { EAST }
        when EAST { NORTH }
    }
}

sub build-grid($input) {
    my @lines = $input.lines;
    my $row-offset = (@lines.elems / 2).floor;
    my $col-offset = (@lines.first.comb.elems / 2).floor;

    for @lines.kv -> $line-num, $line {
        for $line.comb.kv -> $char-num, $char {
            %grid{ $($char-num - $col-offset, $line-num - $row-offset) } = $char;
        }
    }
}

sub tick {
    %grid{$current-node} //= '.';

    if %grid{$current-node} eq '#' {
        $facing = turn($facing, :cw);
        %grid{$current-node} = '.';
    }
    else {
        $facing = turn($facing, :ccw);
        %grid{$current-node} = '#';
        ++$infected;
    }

    $current-node = ($current-node.Array Z+ $facing.value.Array);
}

sub MAIN {
    build-grid('day_22.input'.IO.slurp.chomp);

    tick for ^10_000;
    say $infected;
}
