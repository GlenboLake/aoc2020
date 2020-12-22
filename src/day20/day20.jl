module Day20

using AoC2020
using Test

VALUE = Dict(
    '.' => 0,
    '#' => 1
)

"""
The edge of a puzzle piece is a 10-character sequence of # and .
The edge ID is the numeric representation of this sequence as a binary
number, using 0 for . and 1 for #
"""
function edgeId(chars::Array{Char})
    value = 0
    for ch ∈ chars
        value = value << 1 | VALUE[ch]
    end
    value
end
edgeId(s::AbstractString) = edgeId(collect(s))

"""
Because pieces can be flipped, we need a way to refer to both
orientations of an edge with the same ID. These two edges have
different IDs, but are the same pattern reversed:

####...... => 960
......#### => 15

The minimum of these two values, 15, will be used as the unordered ID
"""
function unorderedInt(chars::Array{Char})
    minimum(edgeId.([chars, reverse(chars)]))
end
unorderedInt(s::AbstractString) = unorderedInt(collect(s))
unorderedInt(num::Int) = min(num, parse(Int, reverse(bitstring(num))[1:10], base=2))

@test unorderedInt("..##.#..#.") == 0b0011010010
@test unorderedInt("##..#.....") == 0b0000010011
@test unorderedInt(710) == 397
@test unorderedInt(397) == 397

Tile = Vector{Int}
CharGrid = Array{Char,2}

@enum PieceType corner edge middle

struct PuzzlePiece
    id::Int
    contents::Array{Char,2}
    type::PieceType
end

using Base
function Base.show(io::IO, piece::PuzzlePiece)
    rows = size(piece.contents)[1]
    grid = join([join(piece.contents[r,:]) for r ∈ 1:rows], "\n")
    println(io, "$(piece.id) ($(piece.type))")
    print(io, grid)
end

@enum Edge top right bottom left

function getEdge(piece::PuzzlePiece, which::Edge)
    chars = begin
        which == top ? piece.contents[begin,:] :
        which == right ? piece.contents[:,end] :
        which == bottom ? reverse(piece.contents[end,:]) :
        reverse(piece.contents[:,begin])
    end
    edgeId(chars)
end

edges(piece::PuzzlePiece) = map(edge->getEdge(piece,edge),instances(Edge))
unorderedEdges(piece::PuzzlePiece) = unorderedInt.(edges(piece))

function rotate!(piece::PuzzlePiece)
    piece.contents[:,:] = rotr90(piece.contents)
end

function flip!(piece::PuzzlePiece)
    piece.contents[:,:] = piece.contents[:,end:-1:begin]
end

function parseImage(tiles::Vector{SubString{String}})
    edgeCounts = Dict{Int,Int}()
    tileEdges = Dict{Int,Tile}()
    tileContents = Dict{Int,Array{Char,2}}()
    for tile ∈ tiles
        id, lines = split(tile, '\n', limit=2)
        id = parse(Int, id[6:9])
        img = permutedims(reshape(collect(replace(lines, '\n'=>"")),(10,10)))
        tileContents[id] = img
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

    function pieceType(tile::Tile)
        numEdges = length(filter(.==(1), map(edge->edgeCounts[edge], tile)))
        if numEdges == 2 corner
        elseif numEdges == 1 edge
        elseif numEdges == 0 middle
        else throw("WHAAAAAT? $(map(edge->edgeCounts[edge], tile))")
        end
    end
    pieces = Dict([k => pieceType(v) for (k,v) ∈ tileEdges])
    pieces = [
        PuzzlePiece(id, tileContents[id], pieceType(tileEdges[id]))
        for id ∈ keys(tileContents)
    ]
    borders = keys(filter(edge->edge.second==1, edgeCounts))

    pieces, borders
end

function part1(filename::String = "input.txt")
    tiles = split(readInput(joinpath(@__DIR__, filename)), "\n\n")
    pieces, _ = parseImage(tiles)
    corners = filter(p->p.type==corner, pieces)
    prod(map(piece->piece.id, corners))
end

flush(stdout)
@test part1("sample.txt") == 20899048083289
@show part1()

Puzzle = Array{Union{PuzzlePiece,Nothing}}

function Base.show(io::IO, puzzle::Puzzle)
    println(io)
    nullPiece = fill('-', 10, 10)
    nRows, nCols = size(puzzle)
    for ri ∈ 1:nRows
        pieces = map(p -> begin
            if p isa PuzzlePiece
                p.contents
            else
                nullPiece
            end
        end, puzzle[ri,:])
        # print(io, pieces)
        for pieceRow ∈ 1:10
            println(io, join(join.(map(p->p[pieceRow,:], pieces)), " "))
        end
        print(io, '\n')
    end
end

# This could be a multiline string, but when the editor keeps stripping newlines....
monster = stringAsGrid("                  # \n#    ##    ##    ###\n #  #  #  #  #  #   ")
monsterPoints = map(c->collect(Tuple(c).-(1,1)), filter(c->monster[c]=='#', CartesianIndices(monster)))

function checkRoughness(grid::Array{Char,2})
    maxRow, maxCol = size(grid) .- size(monster) .+ (1,1)
    points = Set{CartesianIndex}()
    for row ∈ 1:maxRow, col ∈ 1:maxCol
        toCheck = map(p->CartesianIndex((p.+(row,col))...), monsterPoints)
        whatsThere = map(p->grid[p], toCheck)
        if all(.==('#'), whatsThere)
            union!(points, toCheck)
        end
    end
    length(points) > 0 ? length(filter(.==('#'), grid)) - length(points) : nothing
end

sample = stringAsGrid(""".####...#####..#...###..
#####..#..#.#.####..#.#.
.#.#...#.###...#.##.##..
#.#.##.###.#.##.##.#####
..##.###.####..#.####.##
...#.#..##.##...#..#..##
#.##.#..#.#..#..##.#.#..
.###.##.....#...###.#...
#.####.#.#....##.#..#.#.
##...#..#....#..#...####
..#.##...###..#.#####..#
....#.##.#.#####....#...
..##.##.###.....#.##..#.
#...#...###..####....##.
.#.##...#.##.#.#.###...#
#.###.#..####...##..#...
#.###...#.##...#.######.
.###.###.#######..#####.
..##.#..#..#.#######.###
#.#..##.########..#..##.
#.#####..#.#...##..#....
#....##..#.#########..##
#...#.....#..##...###.##
#..###....##.#...##.##.#""")
@test checkRoughness(sample) == 273

function part2(filename::String = "input.txt")
    tiles = split(readInput(joinpath(@__DIR__, filename)), "\n\n")
    pieces, borders = parseImage(tiles)

    sz = Int(√length(tiles))

    pieceById(id::Int) = pop!(filter(p->p.id==id, pieces))

    puzzle = Puzzle(nothing, sz, sz)

    remainingPieces() = setdiff(pieces, puzzle)

    # Fill out the top row
    row = 1
    # Start with an arbitrary corner
    piece = pop!(filter(p->p.type==corner, pieces))
    puzzle[1,1] = piece
    # Rotate it so it's the top-left
    topEdge = unorderedInt(getEdge(piece, top))
    leftEdge = unorderedInt(getEdge(piece, left))
    while topEdge ∉ borders || leftEdge ∉ borders
        rotate!(piece)
        topEdge = unorderedInt(getEdge(piece, top))
        leftEdge = unorderedInt(getEdge(piece, left))
    end
    # Move to the right, piece by piece
    for col ∈ 2:sz
        # println("Check to the right of $(puzzle[row,col-1])")
        seek = getEdge(puzzle[row,col-1], right)
        piece = pop!(filter(p->unorderedInt(seek) ∈ unorderedEdges(p), remainingPieces()))
        puzzle[row,col] = piece
        if seek ∈ edges(piece)
            # We don't actually want the same edge in the other piece; we want its reverse
            flip!(piece)
        end
        while unorderedInt(getEdge(piece, left)) ≠ unorderedInt(seek)
            rotate!(piece)
        end
    end
    # For the rest of the rows, use the piece above it to complete
    for row ∈ 2:sz
        for col ∈ 1:sz
            seek = getEdge(puzzle[row-1, col], bottom)
            piece = pop!(filter(p->unorderedInt(seek) ∈ unorderedEdges(p), remainingPieces()))
            puzzle[row,col] = piece
            if seek ∈ edges(piece)
                flip!(piece)
            end
            while unorderedInt(getEdge(piece, top)) ≠ unorderedInt(seek)
                rotate!(piece)
            end
        end
    end
    # Now, you're ready to check the image for sea monsters.
    # The borders of each tile are not part of the actual image; start by removing them
    img = map(piece->piece.contents[begin+1:end-1,begin+1:end-1], puzzle)
    img = vcat([hcat(img[i,:]...) for i ∈ 1:sz]...)
    # 8 permutations of image: 4 rotations for each flip
    for _ ∈ 1:2
        for _ ∈ 1:4
            img = rotr90(img)
            roughness = checkRoughness(img)
            roughness == nothing || return roughness
        end
        img = permutedims(img)
    end
end

@test part2("sample.txt") == 273
@show part2()

end  # module Day20
