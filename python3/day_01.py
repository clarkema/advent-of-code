#! /usr/bin/env python3

# This is a Python 3 solution to day one of 2017's Advent of Code; see
# http://adventofcode.com/2017/day/1 for the full puzzle.

import collections

def captcha_sum(digits, rotation):
    d = [int(d) for d in digits]
    n = collections.deque(d)
    n.rotate(-rotation)

    return sum([x[0] for x in zip(d, n) if x[0] == x[1]])

with open('day_01.input') as input_file:
    input = input_file.read().replace('\n', '')

print('Part 1:', captcha_sum(input, 1))
print('Part 2:', captcha_sum(input, len(input)//2))
