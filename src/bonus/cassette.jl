#=
An extra puzzle! It's not from Topaz, but it makes me happy enough.

https://www.reddit.com/r/adventofcode/comments/kmzuc8/one_extra_puzzle_to_end_this_year/
https://csokavar.hu/projects/casette/
=#
module Cassette

using AoC2020

function solve(input::String = readInput(joinpath(@__DIR__, "cassette.txt")))
    lines = map(line->parse.(Int, split(line, ",")), splitLines(input))
    countPeaks(line) = length(filter(triple->triple[1] < triple[2] && triple[2] >= triple[3], collect(zip(line, line[2:end], line[3:end]))))
    freqs = map(line->countPeaks(line)÷4-1, lines)
    nums = map(x->parse(Int, join(x[2:6]), base=3), Iterators.partition(freqs, 8))
    join(map(Char, nums))
end

println(solve())

end  # module Cassette
