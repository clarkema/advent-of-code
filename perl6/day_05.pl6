#!/usr/bin/env perl6

my Int @instructions = 'day_05.input'.IO.lines.map: *.Int;
my $index = 0;
my $stop = @instructions.Int - 1;

for 1..Inf -> $i {
    my $jump = @instructions[$index];

    $jump >= 3 ?? @instructions[$index]--
               !! @instructions[$index]++;

    $index += $jump;

    if $index > $stop {
        say $i;
        exit;
    }
}
