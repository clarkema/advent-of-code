#! ruby

require 'set'

def part_2(drifts)
    seen = Set.new
    drifts.cycle.reduce do |acc, n|
        new = acc + n
        break new unless seen.add?(new)
        new
    end
end

lines = File.new("day_01.input").each_line.map { |l| l.to_i }

puts "Part 1: #{lines.sum}"
puts "Part 2: #{part_2(lines)}"
