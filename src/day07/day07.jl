module Day06

using AoC2020

function parseRule(rule::AbstractString)
    # println("-----")
    # println(rule)
    color = match(r"^([a-z ]+) bags contain", rule)[1]
    counts = Dict(map(m -> (m[2], parse(Int, m[1])), eachmatch(r"(\d+) ([a-z ]+) bags?", rule)))
    color, counts
end

function canHold(bagType::AbstractString, rules::Dict)
    items::Array{AbstractString} = []
    for (container, options) ∈ rules
        if bagType ∈ keys(options)
            push!(items, container)
        end
    end
    items
end

function day07(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    rules = Dict(parseRule.(splitLines(input)))
    myBag = "shiny gold"

    # Part 1: Find bags that can hold shiny gold, then all bags that can
    # hold those bags, etc., until there are no new bags to check
    options = Set()
    newItems = canHold(myBag, rules)
    while !isempty(newItems)
        check = pop!(newItems)
        if check ∈ options
            continue
        end
        push!(options, check)
        before = copy(newItems)
        push!(newItems, canHold(check, rules)...)
    end
    part1 = length(options)

    # Part 2: Find the total size for each bag type
    bagSizes = Dict{AbstractString,Int}()
    while myBag ∉ keys(bagSizes)
        for rule ∈ rules
            outerBag, contents = rule
            all([r ∈ keys(bagSizes) for (r, c) ∈ contents]) || continue
            size = sum([count*(bagSizes[bag]+1) for (bag, count) ∈ contents])
            bagSizes[outerBag] = size
        end
    end
    part2 = bagSizes[myBag]

    part1, part2
end

part1, part2 = day07()
flush(stdout)
println("Part 1: $part1")
println("Part 2: $part2")

end  # module Day07
