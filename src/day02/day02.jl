module Day02

using AoC2020

function parseLine(line::String)
    (a, b, ch, password) = match(r"^(\d+)-(\d+) ([a-z]): ([a-z]+)$", line).captures
    parse(Int, a), parse(Int, b), ch, password
end

function validate1(line::Tuple)
    (min, max, letter, password) = line
    count(letter, password) in min:max
end

function validate2(line::Tuple)
    (pos1, pos2, letter, password) = line
    (password[pos1:pos1]==letter) ⊻ (password[pos2:pos2] == letter)
end

function day02(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    lines = parseLine.(splitLines(input))
    part1 = length(filter(line -> validate1(line), lines))
    part2 = length(filter(line -> validate2(line), lines))
    (part1, part2)
end

(part1, part2) = day02()

println("Part 1: $part1")
println("Part 2: $part2")


end
