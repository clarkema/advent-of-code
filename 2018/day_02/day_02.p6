#! perl6

sub part_1(@lines) {
    given @lines>>.comb>>.Bag {
        my $twos =  @_>>.values>>.grep(2).grep(*.elems > 0).elems;
        my $threes =  @_>>.values>>.grep(3).grep(*.elems > 0).elems;
        return $twos * $threes;
    }
}

sub part_2(@lines) {
    for @lines -> $line {
        my @master = $line.comb;

        for @lines -> $cand {
            next if $line eq $cand;
            my @mask = @master >>eq<< $cand.comb;
            next if @mask.grep(!*).elems > 1;
            return join '', ({ $^v if @mask[$^i] } for @master.kv);
        }
    }
}

given "day_02.input".IO.lines {
    say "Part 1: ", part_1(@_);
    say "Part 2: ", part_2(@_);
}
