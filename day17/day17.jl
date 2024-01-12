using DataStructures

struct Node
    x::Int
    y::Int
    prev::Union{Tuple{Int, Int}, Nothing}
    consecutive::Int
end

function neighbors(node::Node)
    n::Vector{Node} = []
    consec_dir = node.prev === nothing ? (0, 0) : (node.x - node.prev[1], node.y - node.prev[2])
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
        (dx, dy) == .-consec_dir && continue # Can't go backwards
        if (dx, dy) == consec_dir && node.consecutive >= 3
            continue
        elseif (dx, dy) == consec_dir
            push!(n, Node(node.x + dx, node.y + dy, (node.x, node.y), node.consecutive + 1))
        else
            push!(n, Node(node.x + dx, node.y + dy, (node.x, node.y), 1))
        end
    end
    return n
end

function ultraneighbors(node)
    node.prev === nothing && return [Node(1, 2, (1, 1), 1), Node(2, 1, (1, 1), 1)]

    n::Vector{Node} = []
    consec_dir = (node.x - node.prev[1], node.y - node.prev[2])
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
        (dx, dy) == .-consec_dir && continue # Can't go backwards
        if (dx, dy) == consec_dir && node.consecutive >= 10
            continue
        elseif (dx, dy) == consec_dir
            push!(n, Node(node.x + dx, node.y + dy, (node.x, node.y), node.consecutive + 1))
        elseif node.consecutive >= 4
            push!(n, Node(node.x + dx, node.y + dy, (node.x, node.y), 1))
        end
    end
    return n
end

@inline function withingrid(grid, m)
    return m.x <= size(grid, 2) && m.y <= size(grid, 1) && m.x > 0 && m.y > 0
end

function dijkstra(grid, nhbr_func; start_coords=(1,1))
    s = Node(start_coords[1], start_coords[2], nothing, 0)
    pq = PriorityQueue{Node, Int}()
    enqueue!(pq,  s=> 0)
    dist::Dict{Node, Int} = Dict(s => 0)
    visited::Set{Node} = Set()
    prev::Dict{Node, Node} = Dict()
    while !isempty(pq)
        u = dequeue!(pq)
        push!(visited, u)
        for v in nhbr_func(u) |> filter(m -> withingrid(grid, m) && !(m in visited))
            alt = dist[u] + grid[v.y, v.x]
            if alt < get(dist, v, typemax(Int))
                dist[v] = alt
                prev[v] = u
                haskey(pq, v) && delete!(pq, v)
                enqueue!(pq, v => alt)
            end
        end
    end
    return dist
end

function part1(grid)
    dist = dijkstra(grid, neighbors)
    return minimum(dist[k] for k in keys(dist) if (k.y, k.x) == size(grid))
end

function part2(grid)
    dist = dijkstra(grid, ultraneighbors)
    return minimum(dist[k] for k in keys(dist) if (k.y, k.x) == size(grid) && k.consecutive >= 4)
end

function main()
    input = parse.(Int, stack(collect.(readlines("day17/input.txt")), dims=1))
    println("Part 1: ", part1(input))
    println("Part 2: ", part2(input))
end

main()
