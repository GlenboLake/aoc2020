module Day11

using AoC2020

FLOOR = '.'
EMPTY = 'L'
TAKEN = '#'

struct Layout
    grid::Array{Char,2}
    Layout(s::String) = new(stringAsGrid(s))
    Layout(a::Array{Char,2}) = new(a)
end

using Base
function Base.:(==)(a::Layout, b::Layout)
    a.grid == b.grid
end

function Base.show(io::IO, x::Layout)
    numRows = size(x.grid)[1]
    print(io, "\n" * join([join(x.grid[r,:]) for r in 1:numRows], '\n'))
end

function countNeighbors(row::Int, col::Int, layout::Layout)
    nRows, nCols = size(layout.grid)
    rowRange = max(1, row-1):min(nRows, row+1)
    colRange = max(1, col-1):min(nCols, col+1)
    # @show row, col, layout

    takenSeats = sum(layout.grid[rowRange,colRange] .== TAKEN)
    # Don't count this seat
    if layout.grid[row,col] == TAKEN
        takenSeats -= 1
    end
    takenSeats
end

function countLineOfSight(row::Int, col::Int, layout::Layout)
    # Get every pair combination of 1/0/-1 except (0,0)
    nRows, nCols = size(layout.grid)
    valid(coord::CartesianIndex) = coord[1] ∈ 1:nRows && coord[2] ∈ 1:nCols
    dirs = map(coord -> CartesianIndex(coord), setdiff(Base.Iterators.product(-1:1, -1:1), [(0,0)]))
    total = 0
    seat = CartesianIndex(row, col)
    for dir ∈ dirs
        coord = seat + dir
        while valid(coord) && layout.grid[coord] == FLOOR
            coord += dir
        end
        if valid(coord) && layout.grid[coord] == TAKEN
            total += 1
        end
    end
    total
end

function iterate(layout::Layout, neighborFunc::Function = countNeighbors)
    newGrid = copy(layout.grid)
    for i ∈ CartesianIndices(newGrid)
        currentSeat = layout.grid[i]
        neighbors = neighborFunc(i[1], i[2], layout)
        if currentSeat == EMPTY && neighbors == 0
            newGrid[i] = TAKEN
        elseif currentSeat == TAKEN && neighbors >= 4
            newGrid[i] = EMPTY
        end
    end
    Layout(newGrid)
end



function day11(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    seats = Layout(input)
    oldSeats = nothing
    while seats != oldSeats
        @show seats
        # print('.')
        oldSeats = seats
        seats = iterate(seats, countLineOfSight)
    end
    @show seats
    sum(seats.grid .== TAKEN)
end

sample = """L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"""

flush(stdout)
println(day11(sample))

end  # module Day11
