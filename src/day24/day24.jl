module Day24

using AoC2020
using Test

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

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    tiles = splitLines(input)
    blackTiles = Set{Vector{Int}}()
    for tile in tiles
        pos = followPath(tile)
        if pos ∈ blackTiles
            pop!(blackTiles, pos)
        else
            push!(blackTiles, pos)
        end
    end
    length(blackTiles)
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

end # module Day24
