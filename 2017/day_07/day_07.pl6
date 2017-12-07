#!/usr/bin/env perl6

grammar Program {
    rule TOP { <name> '('<weight>')' <supports>? }
    token name { <[a..z]>+ }
    token weight { \d+ }
    token supports { <.sep> <supported> }
    token sep { '->' }
    token supported { .* }
}

class Tree {
    has Str $.name;
    has Int $.weight;
    has Str @.child-names;
    has Tree @.children;
    has Tree $.up is rw;

    method Str {
        @.children ?? "$.name ({self.branch-weight}) [@.children.join(", ")]"
                   !! "$.name ($.weight)" 
    }

    method branch-weight {
        $.weight + [+] @.children.map: *.branch-weight
    }

    method is-balanced {
        [==] @.children.map: *.branch-weight;
    }

    method root {
        $.up ?? $.up.root !! self;
    }
}

sub build-tree(%nodes) {
    for %nodes.values -> $n {
        $n.children = $n.child-names.map({%nodes{$_}});

        .up = $n for $n.children;
    }
}

sub MAIN {
    my %nodes;

    for 'day_07.input'.IO.lines {
        if my $m = Program.parse($_) {
            my $n = Tree.new(name => $m<name>.Str, weight => $m<weight>.Int);

            if $m<supports> {
                $n.child-names = $m<supports><supported>.Str.comb(/<[a..z]>+/);
            }

            %nodes{$n.name} = $n;
        } else {
            die "Failed to parse $_";
        }
    }

    build-tree(%nodes);

    my Tree $root = %nodes.pick.value.root;

    for $root.children[2].children[2].children -> $c {
        say $c.is-balanced;
    };
}
