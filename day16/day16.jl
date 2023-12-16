struct Beam
    coords::Tuple{Int,Int}
    dir::Char
end

@inline function withinGrid(grid, coords)
    return coords[1] <= size(grid)[1] &&
           coords[1] >= 1 &&
           coords[2] <= size(grid)[2] &&
           coords[2] >= 1
end

function nextCoords(grid, dir, coords)
    r, c = coords
    n = []
    if grid[r, c] == '.'
        dir == 'v' && push!(n, Beam((r + 1, c), 'v'))
        dir == '^' && push!(n, Beam((r - 1, c), '^'))
        dir == '>' && push!(n, Beam((r, c + 1), '>'))
        dir == '<' && push!(n, Beam((r, c - 1), '<'))
    elseif grid[r, c] == '-'
        dir == '>' && push!(n, Beam((r, c + 1), '>'))
        dir == '<' && push!(n, Beam((r, c - 1), '<'))
        dir == 'v' && push!(n, Beam((r, c - 1), '<'), Beam((r, c + 1), '>'))
        dir == '^' && push!(n, Beam((r, c - 1), '<'), Beam((r, c + 1), '>'))
    elseif grid[r, c] == '|'
        dir == '^' && push!(n, Beam((r - 1, c), '^'))
        dir == 'v' && push!(n, Beam((r + 1, c), 'v'))
        dir == '<' && push!(n, Beam((r + 1, c), 'v'), Beam((r - 1, c), '^'))
        dir == '>' && push!(n, Beam((r + 1, c), 'v'), Beam((r - 1, c), '^'))
    elseif grid[r, c] == '/'
        dir == '>' && push!(n, Beam((r - 1, c), '^'))
        dir == '<' && push!(n, Beam((r + 1, c), 'v'))
        dir == 'v' && push!(n, Beam((r, c - 1), '<'))
        dir == '^' && push!(n, Beam((r, c + 1), '>'))
    elseif grid[r, c] == '\\'
        dir == '>' && push!(n, Beam((r + 1, c), 'v'))
        dir == '<' && push!(n, Beam((r - 1, c), '^'))
        dir == 'v' && push!(n, Beam((r, c + 1), '>'))
        dir == '^' && push!(n, Beam((r, c - 1), '<'))
    end
    return [b for b in n if withinGrid(grid, b.coords)]
end

function pushOrAdd!(d, k, v)
    if haskey(d, k)
        push!(d[k], v)
    else
        d[k] = [v]
    end
end

function energize!(grid, beam::Beam, visited)
    if haskey(visited, beam.coords) && beam.dir in visited[beam.coords]
        return
    end

    pushOrAdd!(visited, beam.coords, beam.dir)

    for n in nextCoords(grid, beam.dir, beam.coords)
        energize!(grid, n, visited)
    end
    return visited
end

function part1(input, init = Beam((1, 1), '>'))
    visited = Dict()
    energize!(input, init, visited)
    return length(visited)
end

function part2(input)
    best = 0
    nrows, ncols = size(input)

    for c = 1:ncols
        best = max(best, part1(input, Beam((1, c), 'v')))
        best = max(best, part1(input, Beam((nrows, c), '^')))
    end

    for r = 1:nrows
        best = max(best, part1(input, Beam((r, 1), '>')))
        best = max(best, part1(input, Beam((r, ncols), '<')))
    end

    return best

end

function main()
    input = stack(collect.(readlines("day16/input.txt")), dims = 1)
    println("Part 1: ", part1(input))
    println("Part 2: ", part2(input))
end

main()
