#! perl6

my @drift = "day_01.input".IO.words>>.Int;

say "Part 1: ", @drift.sum;

sub part_2_loop {
    my %seen;
    my $acc = 0;

    loop {
        for @drift {
            $acc += $_;
            return $acc if %seen{$acc}++;
        }
    }
}

sub part_2_set_reduce {
    my $seen = SetHash.new;

    (|@drift xx *).reduce: {
        my $new = $^a + $^b;
        return $new if $seen ∋ $new;
        $seen{$new}++;
        $new
    }
}

sub part_2_hash_reduce {
    my %seen;

    (|@drift xx *).reduce: {
        my $new = $^a + $^b;
        return $new if %seen{$new}++;
        $new
    }
}

say "Part 2 (loop): ", part_2_loop();
say "Part 2 (set reduce): ", part_2_set_reduce();
say "Part 2 (hash_reduce): ", part_2_hash_reduce();
say "Part 2 (produce): ", ([\+] |@drift xx *).repeated.first;
