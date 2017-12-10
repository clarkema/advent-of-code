#! /usr/bin/env perl6

my @salt = [17, 31, 73, 47, 23];

sub sparse-hash(@list, @lengths, :$rounds) {
    my $cur = 0;
    my $skip = 0;

    for ^$rounds {
        for @lengths -> $len {
            my @indexes  = ($cur ..^ $cur + $len).map({$^l % @list});
            my @reversed = @list[@indexes].reverse;

            for ^@indexes -> $i {
                @list[@indexes[$i]] = @reversed[$i];
            }

            $cur = ($cur + $len + $skip) % @list;
            $skip++;
        }
    }

    @list;
}

sub dense-hash(@list, @lengths, :$rounds) {
    do [+^] $_ for sparse-hash(@list, @lengths, :$rounds).rotor(16);
}

sub MAIN {
    my $input = 'day_10.input'.IO.slurp.chomp;

    say "Part 1: ", [*] sparse-hash(
        (0..255).Array,
        $input.comb(/\d+/).map(*.Int),
        :rounds(1)
    )[0,1];

    say "Part 2: ", dense-hash(
        (0..255).Array,
        $input.comb.map(&ord).Array.append(@salt),
        :rounds(64)
    ).map(*.fmt("%.2X")).join('');
}
