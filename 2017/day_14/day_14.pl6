#! /usr/bin/env perl6

my @salt = [17, 31, 73, 47, 23];

# Copypasta from day 10

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

# end of day 10


sub build-row($input) {
    my @row-input = $input.comb.map(&ord).Array.append(@salt);
    my $hash = dense-hash(
        (0..255).Array,
        @row-input,
        :rounds(64)
    );

    $hash.fmt("%.8b").comb(/\d/).map(*.Int).Array;
}

#my $input = "oundnydw";
my $input = "flqrgnkx";

# Part 1
#say [+] do for ^128 -> $row {
#    my @row-input = "$input-$row".comb.map(&ord).Array.append(@salt);
#    my $hash = dense-hash(
#        (0..255).Array,
#        @row-input,
#        :rounds(64)
#    );

#    #$hash.fmt("%.2x").say;
#    $hash.fmt("%.8b").comb('1').sum;
#}

# Part 2
# Build the full 128x128 array, populate it, and then scan through deleting
# groups as we go

sub delete-cluster(@mem, $i) {
    my @to-check = [$i];

    while @to-check {
        my $curr = @to-check.pop;
        if @mem[$curr] {
            @mem[$curr] = 0;
            @to-check.append: neighbours($i);
        }
    }
}

# Since the 'virual' array is 128x128, the 'neighbours' of any block are its
# index ±128 and ±1, provided that those elements are within bounds.
sub neighbours($index) {
    my $max = 128 * 128;
    gather {
        if ($index - 1) >= 0 && ! ($index %% 128) {
            take $index - 1;
        }
        if ($index + 1) < $max && ! (($index + 1) %% 128) {
            take $index + 1;
        }
        for 128, -128 -> $i {
            take $index + $i if 0 <= ($index + $i) < (128*128);
        }
    }
}

my @memory = Array.new;

for ^128 -> $r {
    @memory.append: build-row("$input-$r");
}

my $clusters-found = 0;

for ^(128*128) -> $i {
    if @memory[$i] {
        # Got a cluser.  Delete our way through it and increment counter
        delete-cluster(@memory, $i);
        $clusters-found++;
    }
}

say $clusters-found;
