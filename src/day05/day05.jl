module Day05

using AoC2020

function parseBinary(num::AbstractString, zero::Char, one::Char)
    mapping = Dict(zero => '0', one => '1')
    parse(Int, "0b" * map(c -> mapping[c], num))
end

function seatID(ticket::AbstractString)
    # First 7 characters are the row, effectively a binary sequence with F=0/B=1
    rowMapping = Dict('F' => '0', 'B' => '1')
    seatMapping = Dict('L' => '0', 'R' => '1')
    row = parseBinary(ticket[1:7], 'F', 'B')
    seat = parseBinary(ticket[8:10], 'L', 'R')
    row * 8 + seat
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
