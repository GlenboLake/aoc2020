module Day20

using AoC2020
using Test

VALUE = Dict(
    '.' => 0,
    '#' => 1
)

function unorderedInt(chars::Array{Char})
    val1 = 0
    for ch ∈ chars
        val1 = val1 << 1 | VALUE[ch]
    end
    val2 = 0
    for ch ∈ reverse(chars)
        val2 = val2 << 1 | VALUE[ch]
    end
    min(val1, val2)
end

@test unorderedInt(collect("..##.#..#.")) == 0b0011010010
@test unorderedInt(collect("##..#.....")) == 0b0000010011

Tile = Vector{Int}

function part1(filename::String = "input.txt")
    tiles = split(readInput(joinpath(@__DIR__, filename)), "\n\n")
    edgeCounts = Dict{Int,Int}()
    tileEdges = Dict{Int,Tile}()
    for tile ∈ tiles
        id, lines = split(tile, '\n', limit=2)
        id = parse(Int, id[6:9])
        img = permutedims(reshape(collect(replace(lines, '\n'=>"")),(10,10)))
        edges = unorderedInt.([
            img[begin,:],
            img[:,begin],
            img[end,:],
            img[:,end],
        ])
        tileEdges[id] = Tile(edges)
        for edge ∈ edges
            if edge ∉ keys(edgeCounts)
                edgeCounts[edge] = 0
            end
            edgeCounts[edge] += 1
        end
    end
    function isCorner(tile::Tile)
        sort(map(edge -> edgeCounts[edge], tile)) == [1,1,2,2]
    end
    corners = filter(kv->isCorner(kv.second), tileEdges)
    prod(keys(corners))
end

flush(stdout)
@test part1("sample.txt") == 20899048083289
@show part1()

end  # module Day20
