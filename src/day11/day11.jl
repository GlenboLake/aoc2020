module Day11

using AoC2020

FLOOR = '.'
EMPTY = 'L'
TAKEN = '#'

Grid = Array{Char,2}

# Function to count adjacent occupied seats (for part 1)
function countNeighbors(row::Int, col::Int, layout::Grid)
    nRows, nCols = size(layout)
    rowRange = max(1, row-1):min(nRows, row+1)
    colRange = max(1, col-1):min(nCols, col+1)
    # @show row, col, layout

    takenSeats = sum(layout[rowRange,colRange] .== TAKEN)
    # Don't count this seat
    if layout[row,col] == TAKEN
        takenSeats -= 1
    end
    takenSeats
end

# Function to count occupied seats via line of sight (for part 2)
function countLineOfSight(row::Int, col::Int, layout::Grid)
    # Get every pair combination of 1/0/-1 except (0,0)
    nRows, nCols = size(layout)
    valid(coord::CartesianIndex) = coord[1] ∈ 1:nRows && coord[2] ∈ 1:nCols
    dirs = map(coord -> CartesianIndex(coord), setdiff(Base.Iterators.product(-1:1, -1:1), [(0,0)]))
    total = 0
    seat = CartesianIndex(row, col)
    for dir ∈ dirs
        coord = seat + dir
        while valid(coord) && layout[coord] == FLOOR
            coord += dir
        end
        if valid(coord) && layout[coord] == TAKEN
            total += 1
        end
    end
    total
end

@doc """
Get the next generation of the grid according to the neighbor function.
"crowded" is the number of people that have to be around an occupied seat
before the person feels crowded and gets up
""" ->
function iterate(layout::Grid, crowded::Int, neighborFunc::Function)
    newGrid = copy(layout)
    for i ∈ CartesianIndices(newGrid)
        currentSeat = layout[i]
        neighbors = neighborFunc(i[1], i[2], layout)
        if currentSeat == EMPTY && neighbors == 0
            newGrid[i] = TAKEN
        elseif currentSeat == TAKEN && neighbors >= crowded
            newGrid[i] = EMPTY
        end
    end
    newGrid
end

function solve(input::String, crowded::Int, neighborFunc::Function)
    seats = stringAsGrid(input)
    oldSeats = nothing
    while seats != oldSeats
        oldSeats = seats
        seats = iterate(seats, crowded, neighborFunc)
    end
    sum(seats .== TAKEN)
end

function day11(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    solve(input, 4, countNeighbors), solve(input, 5, countLineOfSight)
end

flush(stdout)
part1, part2 = day11()

@show part1
@show part2

end  # module Day11
