module Day05

using AoC2020

function seatID(ticket::AbstractString)
    trans(c) = Dict(zip("FBLR", "0101"))[c]
    parse(Int, map(trans, ticket), base=2)
end

function day05(input::String=readInput(joinpath(@__DIR__, "input.txt")))
    lines = splitLines(input)
    seats = seatID.(lines)
    part1 = maximum(seats)
    emptySeats = setdiff(minimum(seats):maximum(seats), seats)
    if length(emptySeats) > 1
        filter!(s -> contains(seats, s-1) ⩓ contains(seats, s+1))
    end
    part2 = pop!(emptySeats)
    part1, part2
end

part1, part2 = day05()

flush(stdout)
println("Part 1: $part1")
println("Part 2: $part2")

end  # module Day05
