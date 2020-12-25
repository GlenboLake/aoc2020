module Day24

using AoC2020
using DataStructures
using Test

TilePos = Vector{Int}

steps = Dict(
    "w"  => [ 0, -2],
    "e"  => [ 0,  2],
    "nw" => [-1, -1],
    "ne" => [-1,  1],
    "sw" => [ 1, -1],
    "se" => [ 1,  1],
)

dirs = r"[ns]?[ew]"

matches = map(m->m.match, collect(eachmatch(dirs, "esew")))
@show matches

function followPath(path::AbstractString)
    @assert reduce(vcat, findall(dirs, path)) == 1:length(path)
    sum(map(m->steps[m.match], eachmatch(dirs, path)))
end

function setup(input::String)
    tiles = splitLines(input)
    blackTiles = Set{TilePos}()
    for tile in tiles
        pos = followPath(tile)
        if pos ∈ blackTiles
            pop!(blackTiles, pos)
        else
            push!(blackTiles, pos)
        end
    end
    blackTiles
end

function neighbors(tile::TilePos)
    map(d->tile .+ d, values(steps))
end

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    length(setup(input))
end

function iterate!(tiles::Set{TilePos})
    neighborCounts = DefaultDict{TilePos,Int}(0)
    for tile ∈ tiles
        @assert length(neighbors(tile)) == 6
        for n ∈ neighbors(tile)
            neighborCounts[n] += 1
        end
        # And make sure this tile is counted even if it has 0 neighbors!
        neighborCounts[tile]
    end
    newTiles = copy(tiles)
    for (pos, count) ∈ sort(collect(neighborCounts))
        if pos ∈ tiles && (count == 0 || count > 2)
            # println("Flipping black tile $pos ($count) to white")
            pop!(newTiles, pos)
        elseif pos ∉ tiles && count == 2
            # println("Flipping white tile $pos ($count) to black")
            push!(newTiles, pos)
        else
            color = pos ∈ tiles ? "black" : "white"
            # println("Leaving $color tile $pos alone ($count)")
        end
    end
    empty!(tiles)
    union!(tiles, newTiles)
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    floor = setup(input)
    for day ∈ 1:100
        iterate!(floor)
    end
    length(floor)
end

sample = """sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew"""

@test part1(sample) == 10
@show part1()

@test part2(sample) == 2208
@show part2()

end # module Day24
