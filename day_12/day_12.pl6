#! /usr/bin/env perl6

class Node {
    has $.id;
    has $!links = ∅;

    method add-link(Node $n) {
        $!links ∪= $n;
    }

    method linked-nodes {
        $!links.keys;
    }

    method Str {
        "Node($!id) [{$!links.keys}]"
    }

    method cluster {
        gather {
            my Node @to_visit = [self];
            my $seen = ∅;

            while my $current = @to_visit.pop {
                next if $current.id ∈ $seen;

                $seen ∪= $current.id;
                @to_visit.append: $current.linked-nodes;

                take $current;
            }
        }
    }

}

my %nodes;

# Build graph

'day_12.input'.IO.lines.map: {
    my ($id, $links) = .split(' <-> ');
    my @links = $links.comb(/\d+/).map: *.Int;

    my $node = %nodes{$id} //= Node.new(:id($id));

    for @links -> $link {
        $node.add-link: %nodes{$link} //= Node.new(:id($link));
    }
}

say "Part 1: ", %nodes{0}.cluster.elems;

# Find groups

my %graph = %nodes.clone;
my $groups = 0;

while %graph {
    $groups++;
    my $start = %graph.pick.value;
    $start.cluster.map: -> $n {
        %graph{$n.id}:delete;
    }
}

say "Part 2: ", $groups;
