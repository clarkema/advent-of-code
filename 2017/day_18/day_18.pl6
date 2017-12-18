#! /usr/bin/env perl6

my subset RegisterName of Str where /^<[a..z]>$/;
my %regs;
my $last_played;
my $current_instruction = 0;

for 'a'..'z' { %regs{$^a} = 0 };

sub interpret(@script) {
    loop {
        my ($cmd, *@args) = @script[$current_instruction];

        execute($cmd, |@args);

        $current_instruction++ unless $cmd eq 'jgz';

        unless 0 <= $current_instruction < @script.elems {
            say "Terminated";
            last;
        }
    }
}

multi execute("set", $reg, $val) {
    %regs{$reg} = get_val($val);
}

multi execute("add", $reg, $val) {
    %regs{$reg} += get_val($val);
}

multi execute("mul", $reg, $val) {
    %regs{$reg} *= get_val($val);
}

multi execute("mod", $reg, $val) {
    %regs{$reg} %= get_val($val);
}

multi execute("snd", $reg) {
    $last_played = get_val($reg);
}

multi execute("rcv", $reg) {
    if %regs{$reg} != 0 {
        %regs{$reg} = $last_played;
        die "RCVing $last_played into {$reg.uc}";
    }
}

multi execute("jgz", $x, $y) {
    if get_val($x) > 0 {
        $current_instruction += get_val($y);
    }
    else {
        $current_instruction++;
    }
}

multi get_val(RegisterName $x) { %regs{$x} }
multi get_val($x) { $x }

interpret('day_18.input'.IO.lines.map({$^l.split(/\s+/).Array}).Array);
