module Day03

using AoC2020

TREE = '#'

function treesOnSlope(grid::Array{Char,2}, right::Int, down::Int)
    (nRows, nCols) = size(grid)
    trees = 0
    col = 1
    for row in 1:down:nRows
        if col > nCols
            col -= nCols
        end
        if grid[row, col] == TREE
            trees += 1
        end
        col += right
    end
    trees
end

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    grid = reduce(vcat, permutedims.(collect.(splitLines(input))))
    treesOnSlope(grid, 3, 1)
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    grid = stringAsGrid(input)

    slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    prod([treesOnSlope(grid, r, d) for (r,d) ∈ slopes])
end

sample = """..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"""

flush(stdout)
println("Part 1: $(part1())")
println("Part 2: $(part2())")

end  # module Day03
