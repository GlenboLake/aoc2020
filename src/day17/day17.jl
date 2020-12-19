module Day17

using AoC2020
using Memoize
using Test

Point = Vector{Int}
ConwayCube = Set{Point}

INPUT = """#.#.#.##
.####..#
#####.#.
#####..#
#....###
###...##
...#.#.#
#.##..##"""

ACTIVE = '#'
INACTIVE = '.'

# All combinations of 0/1/-1, but without (0, 0, 0)
NEIGHBORS = setdiff([Vector([x, y, z]) for x ∈ (-1,0,1), y ∈ (-1,0,1), z ∈ (-1,0,1)], [Vector([0,0,0])])

using Base
function Base.show(io::IO, cube::ConwayCube)
    xs = map(p->p[1], collect(cube))
    ys = map(p->p[2], collect(cube))
    zs = map(p->p[3], collect(cube))
    for z ∈ minimum(zs):maximum(zs)
        println(io, "\nz=$z")
        for x ∈ minimum(xs):maximum(xs)
            for y ∈ minimum(ys):maximum(ys)
                if Point([x,y,z]) ∈ cube
                    print(io, ACTIVE)
                else
                    print(io, INACTIVE)
                end
            end
            print(io, '\n')
        end
    end
end

@memoize neighborDiffs(nDims=3) = setdiff(collect.(Iterators.product([-1:1 for _ ∈ 1:nDims]...)), [zeros(Int, nDims)])

function iterate!(cube::ConwayCube)
    newCube = ConwayCube()
    neighborCounts = Dict{Point, Int}()
    # All items in the cube have the same length, so we can pick one at random to determine the dimensionality
    nDims = length(first(cube))
    # Count neighbors of all nodes that have neighbors by adding 1
    # to every neighbor of each currently active cell
    for p ∈ cube
        # println("Things around $p")
        for diff ∈ neighborDiffs(nDims)
            n = p + diff
            if !haskey(neighborCounts, n)
                neighborCounts[n] = 0
            end
            neighborCounts[n] += 1
        end
    end
    for (point, neighbors) ∈ neighborCounts
        state = point ∈ cube ? ACTIVE : INACTIVE
        if state == INACTIVE && neighbors == 3
            push!(newCube, point)
        elseif state == ACTIVE && neighbors ∈ (2, 3)
            push!(newCube, point)
        end
    end
    empty!(cube)
    union!(cube, newCube)
end

function parseInput(input::String, nDims=3)
    cube = ConwayCube()
    for (i, row) ∈ enumerate(splitLines(input))
        for (j, ch) ∈ enumerate(row)
            if ch == ACTIVE
                push!(cube, Point([i, j, zeros(Int, nDims-2)...]))
            end
        end
    end
    cube
end

function simulate(input::String = INPUT, nDims=3)
    cube = parseInput(input, nDims)
    for _ ∈ 1:6
        iterate!(cube)
    end
    length(cube)
end

part1(input::String = INPUT) = simulate(input, 3)
part2(input::String = INPUT) = simulate(input, 4)
sample = """.#.
..#
###"""

@test part1(sample) == 112
@show part1()
@test part2(sample) == 848
@show part2()

end # module Day17
