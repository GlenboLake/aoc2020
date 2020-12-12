module Day12

using AoC2020

Dir = Vector{Int}
Coord = Array{Int,1}


NORTH = [1, 0]
SOUTH = [-1, 0]
EAST = [0, 1]
WEST = [0, -1]

# Used for printing out ship status
dirNames = Dict(
    NORTH => "North",
    SOUTH => "South",
    EAST => "East",
    WEST => "West"
)

function rotateLeft(vector::Vector, angle::Int)
    rotationMatrix = [ cosd(angle)  sind(angle)
                      -sind(angle)  cosd(angle)]
    Int.(rotationMatrix * vector)
end

function rotateRight(vector::Vector, angle::Int)
    rotationMatrix = [cosd(angle)  -sind(angle)
                      sind(angle)   cosd(angle)]
    Int.(rotationMatrix * vector)
end

mutable struct Ship
    dir::Dir
    pos::Coord
end

using Base
function Base.show(io::IO, ship::Ship)
    lat,long = abs.(ship.pos)
    latDir = ship.pos[1] < 0 ? 'S' : 'N'
    longDir = ship.pos[2] < 0 ? 'W' : 'E'
    s = "Ship @ $lat$latDir,$long$longDir facing $(dirNames[ship.dir])"
    print(io, s)
end

function command(ship::Ship, instruction::Tuple{Char,Int})
    cmd, amount = instruction
    if cmd == 'L'
        ship.dir = rotateLeft(ship.dir, amount)
    elseif cmd == 'R'
        ship.dir = rotateRight(ship.dir, amount)
    else
        dir = cmd == 'F' ? ship.dir :
              cmd == 'N' ? NORTH :
              cmd == 'S' ? SOUTH :
              cmd == 'E' ? EAST :
              WEST # Only other option
        ship.pos += amount.*dir
    end
end

parseInput(input::String) = map(line -> (line[1], parse(Int, line[2:end])), splitLines(input))

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    instructions = parseInput(input)
    ship = Ship(EAST, [0,0])
    for i ∈ instructions
        command(ship, i)
    end
    sum(abs.(ship.pos))
end

function command(ship::Coord, waypoint::Coord, instruction::Tuple{Char,Int})
    # Note: Update ship[:] and waypoint[:] to update the existing objects
    # instead of replacing them
    cmd, amount = instruction
    if cmd == 'F'
        ship[:] = ship + amount .* waypoint
    elseif cmd == 'L'
        waypoint[:] = rotateLeft(waypoint, amount)
    elseif cmd == 'R'
        waypoint[:] = rotateRight(waypoint, amount)
    else
        dir = cmd == 'N' ? NORTH :
              cmd == 'S' ? SOUTH :
              cmd == 'E' ? EAST :
              WEST # Only other option
        waypoint[:] = waypoint + amount .* dir
    end
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    instructions = parseInput(input)
    ship::Coord = [0,0]
    waypoint::Coord = [1,10]
    for i ∈ instructions
        command(ship, waypoint, i)
    end
    sum(abs.(ship))
end

flush(stdout)
@show part1()
@show part2()

end  # module Day12
