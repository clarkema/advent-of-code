#! lua

function read_file(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function sum(a)
    local acc = 0;
    for _, v in ipairs(a) do
        acc = acc + v
    end
    return acc
end

function part_2(drift)
    local seen = {}
    local acc = 0

    while true do
        for _, v in ipairs(drift) do
            acc = acc + v;
            if seen[acc] then
                return acc
            else
                seen[acc] = true
            end
        end
    end
end

drift = read_file("day_01.input")

print("Part 1: " .. sum(drift))
print("Part 2: " .. part_2(drift))
