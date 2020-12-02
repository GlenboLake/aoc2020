module Day02

using AoC2020

function validate1(line::SubString)
    (range, letter, password) = split(line)
    letter = rstrip(letter, ':')
    (min, max) = parse.(Int, split(range, "-"))
    count(letter, password) in min:max
end

function validate2(line::SubString)
    (positions, letter, password) = split(line)
    letter = rstrip(letter, ':')
    (a, b) = parse.(Int, split(positions, "-"))
    (password[a]==letter) ⊻ (password[b] == letter)
end

sample = """1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

function day02(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    lines = split(rstrip(input, '\n'), "\n")
    part1 = length(filter(line -> validate1(line), lines))
    part2 = length(filter(line -> validate2(line), lines))
    (part1, part2)
end

println()
println(day02())

end
