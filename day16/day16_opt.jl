#= Shady attempt at optimizing day 16.
This runs about 5x faster than
my original solution
=#

struct Beam
    coords::Tuple{Int,Int}
    dir::UInt8
end

@inline function withinGrid(grid, coords)
    return coords[1] <= size(grid, 1) &&
           coords[1] >= 1 &&
           coords[2] <= size(grid, 2) &&
           coords[2] >= 1
end

# 0x1: ^, 0x2: >, 0x4: v, 0x8: <
# Don't even try to read this function
function nextCoords(grid, dir, coords)
    r, c = coords
    n = []
    if grid[r, c] == '.'
        n = [Beam((r + (dir & 0x4) >> 2 - (dir & 0x1), c + (dir & 0x2) >> 1 - (dir & 0x8) >> 3), dir)]
    elseif grid[r, c] == '-' && (dir == 0x2 || dir == 0x8)
        n = [Beam((r, c + (dir & 0x2) >> 1 - (dir & 0x8) >> 3), dir)]
    elseif grid[r, c] == '-'
        n = [Beam((r, c - 1), 0x8), Beam((r, c + 1), 0x2)]
    elseif grid[r, c] == '|' && (dir == 0x1 || dir == 0x4)
        n = [Beam((r + (dir & 0x4) >> 2 - (dir & 0x1), c), dir)]
    elseif grid[r, c] == '|'
        n =[Beam((r + 1, c), 0x4), Beam((r - 1, c), 0x1)]
    elseif grid[r, c] == '/'
        n = [Beam(
            (r + (dir & 0x8) >> 3 - (dir & 0x2) >> 1, c + (dir & 0x1) - (dir & 0x4) >> 2),
            ((dir & 0x8) >> 1) | ((dir & 0x1) << 1) | ((dir & 0x2) >> 1) | ((dir & 0x4) << 1)
        )]
    elseif grid[r, c] == '\\'
        n = [Beam(
            (r - (dir & 0x8) >> 3 + (dir & 0x2) >> 1, c + (dir & 0x4) >> 2 - (dir & 0x1)),
            ((dir & 0x8) >> 3) | ((dir & 0x1) << 3) | ((dir & 0x2) << 1) | ((dir & 0x4) >> 1)
        )]
    end
    return n
end

@inline function pushOrAdd!(d, k, v)
    if haskey(d, k)
        push!(d[k], v)
    else
        d[k] = Set(v)
    end
end

function energize!(grid, beam::Beam, visited)
    r, c = beam.coords
    !iszero(visited[r,c] & beam.dir) && return

    visited[r,c] |= beam.dir

    for n in nextCoords(grid, beam.dir, beam.coords) |> filter(x -> withinGrid(grid, x.coords))
        energize!(grid, n, visited)
    end
    return visited
end

@inline function part1(input, init = Beam((1, 1), 0x2))
    visited = zeros(UInt8, size(input))
    energize!(input, init, visited)
    return count(!iszero, visited)
end

function part2(input)
    best = 0
    nrows, ncols = size(input)

    for c = 1:ncols
        best = max(best, part1(input, Beam((1, c), 0x4)))
        best = max(best, part1(input, Beam((nrows, c), 0x1)))
    end

    for r = 1:nrows
        best = max(best, part1(input, Beam((r, 1), 0x2)))
        best = max(best, part1(input, Beam((r, ncols), 0x8)))
    end

    return best

end

function main()
    input = stack(collect.(readlines("day16/input.txt")), dims = 1)
    println("Part 1: ", part1(input))
    println("Part 2: ", part2(input))
end

main()
