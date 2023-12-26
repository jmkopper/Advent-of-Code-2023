const DIRS = [(1, 0), (-1, 0), (0, 1), (0, -1)]
function valid_dirs(grid, coords)
    current = grid[coords...]
    steps = []
    if current == '>'
        steps = [(coords[1], coords[2] + 1)]
    elseif current == 'v'
        steps = [(coords[1] + 1, coords[2])]
    elseif current == '<'
        steps = [(coords[1], coords[2]-1)]
    elseif current == '^'
        steps = [(coords[1]-1, coords[2])]
    else 
        steps = [(coords[1] + dr, coords[2] + dc) for (dr, dc) in DIRS]
    end
    valid_steps = []
    for (r, c) in steps
        if r < 1 || c < 1 || r > size(grid, 1) || c > size(grid, 1)
            continue
        end
        if grid[r, c] == '#'
            continue
        end
        if r > coords[1] && grid[r, c] != '^'
            push!(valid_steps, (r, c))
        elseif r < coords[1] && grid[r, c] != 'v'
            push!(valid_steps, (r, c))
        elseif c > coords[2] && grid[r, c] != '<'
            push!(valid_steps, (r, c))
        elseif c < coords[2] && grid[r, c] != '>'
            push!(valid_steps, (r, c))
        end
    end
    return valid_steps
end

function is_intersection(grid, coords)
    if grid[coords...] == '#'
        return false
    end
    steps = [(coords[1] + dr, coords[2] + dc) for (dr, dc) in DIRS]
    counts = 0
    for (r, c) in steps
        if r < 1 || c < 1 || r > size(grid, 1) || c > size(grid, 1)
            continue
        end
        if grid[r, c] == '#'
            continue
        end
        counts += 1
    end
    return counts > 2 || counts == 1
end

build_vertices(grid) = [(r, c) for r in 1:size(grid, 1), c in 1:size(grid, 2) if is_intersection(grid, (r, c))]
function get_edges(grid, vertices)
    edges = Dict()
    for v in vertices
        visited = Set()
        q = [v]
        edges[v] = []
        depth = 0
        while !isempty(q)
            level_size = length(q)
            depth += 1
            while level_size > 0
                u = popfirst!(q)
                level_size -= 1
                push!(visited, u)
                if is_intersection(grid, u) && u != v
                    push!(edges[v], (u, depth))
                    continue
                end
                n = [d for d in valid_dirs(grid, u) if !(d in visited)]
                push!(q, n...)
            end
        end
    end
    return edges
end

function dfs_paths!(fps, edges, root, finish, steps, visited)
    if root == finish
        push!(fps, steps)
        return
    end

    visited[root] = true
    for e in edges[root]
        if haskey(visited, e[1]) && visited[e[1]]
            continue
        end
        dfs_paths!(fps, edges, e[1], finish, steps + e[2] - 1, visited)
    end

    visited[root] = false
end

function part1(grid)
    vertices = build_vertices(grid)
    edges = get_edges(grid, vertices)
    start = (1, 2)
    finish = (size(grid, 1), findfirst(==('.'), grid[end, :]))
    fps = []
    dfs_paths!(fps, edges, start, finish, 0, Dict())
    return maximum(fps)
end

function part2(grid)
    new_grid = copy(grid)
    new_grid[new_grid .!= '#'] .= '.'
    vertices = build_vertices(new_grid)
    edges = get_edges(new_grid, vertices)
    start = (1, 2)
    finish = (size(new_grid, 1), findfirst(==('.'), new_grid[end, :]))
    fps = []
    dfs_paths!(fps, edges, start, finish, 0, Dict())
    return maximum(fps)
end

function main()
    grid = stack(collect.(readlines("day23/input.txt")), dims=1)
    println("Part 1: ", part1(grid))
    println("Part 2: ", part2(grid))
end

main()
