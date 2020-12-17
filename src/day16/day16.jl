module Day16

using AoC2020
using Test

Notes = Dict{AbstractString,Array{UnitRange{Int}}}

function parseInput(input::String)
    notes = Notes()
    f = IOBuffer(input)
    ranges = readuntil(f, "\n\nyour ticket:\n")
    parseTicket(t) = parse.(Int, split(t, ","))
    ticket = parseTicket(readuntil(f, "\n\nnearby tickets:\n"))
    others = parseTicket.(splitLines(read(f, String)))
    for line in splitLines(ranges)
        key = split(line, ':')[begin]
        notes[key] = []
        for i ∈ findall(r"\d+-\d+", line)
            (start, stop) = parse.(Int, match(r"(\d+)-(\d+)", line[i]).captures)
            push!(notes[key], start:stop)
        end
    end
    notes, ticket, others
end

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    notes, _, tickets = parseInput(input)
    ranges = reduce(vcat, values(notes))
    numbers = reduce(vcat, tickets)
    isError(n) = !any(n .∈ ranges)
    errorRate = sum(filter(isError, numbers))
end

sample1 = """class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12"""

@test part1(sample1) == 71
@show part1()

end # module Day16
