startcoords(grid) = first(findall(==('S'), grid))
validneighbors(grid, coords) = checkbounds(Bool, grid, coords) && grid[coords] != '#'

const DIRS = CartesianIndex.([(1, 0), (-1, 0), (0, 1), (0, -1)])

function bfs(grid; max_steps = 200)
    q = [startcoords(grid)]
    steps = 1
    visited = Dict{CartesianIndex,Int}(startcoords(grid) => 0)
    p1 = 0
    while length(q) > 0 && steps <= max_steps
        depth_size = length(q)
        while depth_size > 0
            n = popfirst!(q)
            for v in [n + dir for dir in DIRS] |> filter(x -> validneighbors(grid, x))
                haskey(visited, v) && continue
                visited[v] = steps
                push!(q, v)
            end
            depth_size -= 1
        end
        unique!(q)
        p1 += steps == 64 ? count(x -> x % 2 == 0, values(visited)) : 0
        steps += 1
    end
    evenall = count(x -> x % 2 == 0, values(visited))
    oddall = count(x -> x % 2 == 1, values(visited))
    evencorners = count(x -> x % 2 == 0 && x > 65, values(visited))
    oddcorners = count(x -> x % 2 == 1 && x > 65, values(visited))
    n = div(26501365, size(grid, 1))
    #= Notably, 26501365 = 131 * 202300 + 65, So we fully visit every copy of the grid
    except (1) the extremal ones whose centers we can reach where we lose the corner (odd parity),
    and (2) the extremal ones whose centers we cannot reach but whose corners we can (even parity)
    This all works out exactly because the puzzle was designed that way =#
    p2 = oddall * (n + 1)^2 + evenall * (n^2) - (n + 1) * oddcorners + n * evencorners
    return p1, p2
end

function main()
    grid = stack(collect.(readlines("day21/input.txt")), dims = 1)
    p1, p2 = bfs(grid)
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end

main()
