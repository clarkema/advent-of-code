#! /usr/bin/env perl6

subset RegisterName of Str where { $^c (elem) ('a'..'z').Set }

class Interpreter {
    has Int $!pid;
    has %!regs;
    has $!current-instruction = 0;
    has Channel $.stdin = Channel.new;
    has Channel $.other_proc is rw;
    has $.sent-count = 0;

    submethod BUILD(:$pid) {
        for 'a'..'z' { %!regs{$^a} = 0 };
        %!regs{'p'} = $!pid = $pid.Int;
    }

    method run(@script) {
        loop {
            my ($cmd, *@args) = @script[$!current-instruction];

            self.execute($cmd, |@args);

            $!current-instruction++ unless $cmd eq 'jgz';

            unless 0 <= $!current-instruction < @script.elems {
                say "PID $!pid terminated";
                last;
            }
        }
    }

    multi method execute("set", $reg, $val) {
        %!regs{$reg} = self.get_val($val);
    }

    multi method execute("add", $reg, $val) {
        %!regs{$reg} += self.get_val($val);
    }

    multi method execute("mul", $reg, $val) {
        %!regs{$reg} *= self.get_val($val);
    }

    multi method execute("mod", $reg, $val) {
        %!regs{$reg} %= self.get_val($val);
    }

    multi method execute("snd", $reg) {
        $!sent-count++;
        $!other_proc.send(self.get_val($reg));
    }

    multi method execute("rcv", $reg) {
        for 1..20 {
            if my $val = $!stdin.poll {
                %!regs{$reg} = $val;
                return;
            }
            sleep 0.1;
        }
        die "Deadlock in $!pid";
    }

    multi method execute("jgz", $x, $y) {
        if self.get_val($x) > 0 {
            $!current-instruction += self.get_val($y);
        }
        else {
            $!current-instruction++;
        }
    }

    multi method get_val(RegisterName $x) { %!regs{$x} }
    multi method get_val(Str $x) { $x.Int }
    multi method get_val(Int $x) { $x }
}

sub MAIN() {
    my @script = 'day_18.input'.IO.lines.map({$^l.split(/\s+/).Array});

    my $prog_zero = Interpreter.new(:pid(0));
    my $prog_one  = Interpreter.new(:pid(1));

    $prog_zero.other_proc = $prog_one.stdin;
    $prog_one.other_proc  = $prog_zero.stdin;

    my $p0 = start { $prog_zero.run(@script) };
    my $p1 = start { $prog_one.run(@script) };

    try {
        await($p0, $p1);
        CATCH { when X::Await::Died {} }
    }
    say "Program 1 sent: {$prog_one.sent-count}";
}
