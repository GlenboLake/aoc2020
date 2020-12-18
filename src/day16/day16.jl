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

struct Option
    pos::Int
    field::AbstractString
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    notes, ticket, otherTickets = parseInput(input)
    # Remove bad tickets using logic from part 1
    ranges = reduce(vcat, values(notes))
    isValid(n) = any(n .∈ ranges)
    goodTicket(t) = all(isValid.(t))
    validTickets = [ticket, filter(goodTicket, otherTickets)...]
    numFields = length(ticket)

    # This can probably be done more succinctly, but I don't care anymore
    options = Array{Option,1}()
    for pos ∈ 1:numFields
        numsAtPos = map(ticket -> ticket[pos], validTickets)
        for (field, ranges) ∈ notes
            canFit(n) = any(n .∈ ranges)
            if all(canFit.(numsAtPos))
                push!(options, Option(pos, field))
            end
        end
    end

    function getOptions(pos::Int)
        map(p -> p.field, filter(p -> p.pos==pos, options))
    end
    function getOptions(field::AbstractString)
        map(p -> p.pos, filter(p -> p.field==field, options))
    end

    function byPos()
        Dict([
            pos => getOptions(pos)
            for pos ∈ 1:numFields
        ])
    end
    function byName()
        Dict([
            field => getOptions(field)
            for field ∈ keys(notes)
        ])
    end

    function done()
        Set(length.(values(byPos()))) == Set([1])
    end

    while !done()
        before = copy(options)
        solvedPositions = filter(item -> length(item.second)==1, byPos())
        for item ∈ solvedPositions
            pos = item.first
            field = item.second[1]
            toDelete = map(p -> Option(p, field), setdiff(byName()[field], [pos]))
            setdiff!(options, toDelete)
        end
        if before == options
            # Just in case we hit an unsolvable one
            println("Giving up")
            @show byPos()
            @show byName()
            break
        end
    end
    positions = map(opt -> opt.pos, filter(opt -> startswith(opt.field, "departure"), options))
    prod(map(p->ticket[p], positions))
end

sample2 = """departure class: 0-1 or 4-19
departure row: 0-5 or 8-19
departure seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9"""

expected = 12*11*13
@test part2(sample2) == expected
@show part2()

end # module Day16
