module Day13

using AoC2020

function nextDeparture(schedule::Int, after::Int)
    Int(schedule * ceil(after/schedule))
end

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    buf = IOBuffer(input)
    departure = parse(Int, readline(buf))
    buses = map(x -> parse(Int, x), filter(s -> s .≠ "x", split(readline(buf), ",")))
    departures = map(b -> nextDeparture(b, departure), buses)
    _, busToTake = findmin(departures)
    buses[busToTake] * (departures[busToTake]-departure)
end

function check(offset::Int, buses::Array{Tuple{Int, Int}})
    for (diff, schedule) ∈ buses
        (offset + diff) % schedule == 0 || return false
    end
    true
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    buf = IOBuffer(input)
    readline(buf)
    buses = filter(item -> item[2] ≠ "x", collect(enumerate(split(readline(buf), ","))))
    # Switch to 0-based indexing and parse numbers
    buses = map(item -> (item[1]-1, parse(Int, item[2])), buses)
    # Solve with Chinese Remainder Theorem
    # Variable names modeled after Brilliant's explanation of the theorem:
    # https://brilliant.org/wiki/chinese-remainder-theorem/
    a = [mod((m-offset), m) for (offset, m) ∈ buses]
    n = [m for (_, m) ∈ buses]
    N = prod(n)
    y = N .÷ n
    z = [invmod(yi,ni) for (yi,ni) ∈ zip(y,n)]
    mod(sum(prod.(zip(a,y,z))), N)
end


@show part1()
@show part2()

end  # module Day13
