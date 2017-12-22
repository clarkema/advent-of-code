#!/usr/bin/env perl6

my int @instructions = 'day_05.input'.IO.lines.map: *.Int;
my int $index = 0;
my int $stop = @instructions.elems;
my int $iterations = 0;
my int $jump;

my $current;

while $index < $stop {
    # Even .AT-POS is relatively expensive.  It's cheaper to bind
    # the location to $current than it is to subscript twice.
    $current := @instructions.AT-POS($index);
    $jump = $current;

    $jump >= 3 ?? --$current !! ++$current;

    # This is currently faster than $index += $jump; see
    # https://github.com/rakudo/rakudo/issues/1329
    $index = $index + $jump;
    ++$iterations;
}

say $iterations;
