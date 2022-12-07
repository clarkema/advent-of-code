#! /usr/bin/env raku

my %scores-p1 = <AX AY AZ BX BY BZ CX CY CZ> Z=> 4, 8, 3, 1, 5, 9, 7, 2, 6;
my %scores-p2 = <AX AY AZ BX BY BZ CX CY CZ> Z=> 3, 4, 8, 1, 5, 9, 2, 6, 7;

with "day_02.input".IO.lines».subst(/\s+/) -> @A {
    say 'Part 1: ', %scores-p1{@A}.sum;
    say 'Part 2: ', %scores-p2{@A}.sum;
}
