#! /usr/bin/env perl6

my @list    = 0..255;
my @lengths = 34,88,2,222,254,93,150,0,199,255,39,32,137,136,1,167;
my $cur     = 0;
my $skip    = 0;

for @lengths -> $len {
    my @indexes  = ($cur ..^ $cur + $len).map({$^l % @list});
    my @reversed = @list[@indexes].reverse;

    for ^@indexes -> $i {
        @list[@indexes[$i]] = @reversed[$i];
    }

    $cur = ($cur + $len + $skip) % @list;
    $skip++;
}

say "Finally: ", [*] @list[0,1];
