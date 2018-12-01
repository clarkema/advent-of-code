#! python3

from itertools import cycle, accumulate

def part_2():
    seen = set()
    for x in accumulate(cycle(drift)):
        if x in seen:
            return x
        else:
            seen.add(x)

drift = [int(l) for l in open("day_01.input")]

print(sum(drift))
print(part_2())
