#!/usr/bin/env python3

with open('day_05.input') as input_file:
    lines = input_file.read().split("\n")
    instructions = [int(x) for x in lines]

index = 0
stop = len(instructions) - 1
i = 0

while index <= stop:
    jump = instructions[index];

    if jump >= 3:
        instructions[index] = instructions[index] - 1
    else:
        instructions[index] = instructions[index] + 1

    index = index + jump;
    i = i + 1

print(i)
