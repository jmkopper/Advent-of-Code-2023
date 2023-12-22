struct Brick
    id::Int
    start::Tuple{Int, Int, Int}
    stop::Tuple{Int, Int, Int}
end

left(b::Brick) = min(b.start[1], b.stop[1]) + 1  # 1-indexing gonna kill me
right(b::Brick) = max(b.start[1], b.stop[1]) + 1
front(b::Brick) = min(b.start[2], b.stop[2]) + 1
back(b::Brick) = max(b.start[2], b.stop[2]) + 1
bottom(b::Brick) = min(b.start[3], b.stop[3])
top(b::Brick) = max(b.start[3], b.stop[3])

function parseline(line, i)
    halves = split(line, "~")
    a = split(halves[1], ",") .|> x -> parse(Int, x)
    b = split(halves[2], ",") .|> x -> parse(Int, x)
    return Brick(i, Tuple(a), Tuple(b))
end

function fall!(ground, bricks)
    moved_bricks::Vector{Brick} = []
    stopped_bricks::Vector{Brick} = []
    for brick in bricks
        m = front(brick):back(brick),left(brick):right(brick)
        if (ground[m...] .>= bottom(brick) - 1) |> any
            ground[m...] .= top(brick)
            push!(stopped_bricks, brick)
        else
            new_brick = Brick(brick.id, (brick.start[1], brick.start[2], brick.start[3] - 1), (brick.stop[1], brick.stop[2], brick.stop[3] - 1))
            push!(moved_bricks, new_brick)
        end
    end
    return moved_bricks, stopped_bricks
end

none_below(brick, lowest_at_xy) = !any(lowest_at_xy[(x, y)] < bottom(brick) for x in left(brick):right(brick), y in front(brick):back(brick))

function lowest_bricks(bricks, maxx, maxy)
    lowest_at_xy = Dict((x, y) => typemax(Int) for x in 1:maxx, y in 1:maxy)
    for brick in bricks
        for x in left(brick):right(brick), y in front(brick):back(brick)
            lowest_at_xy[(x, y)] = min(lowest_at_xy[(x, y)], bottom(brick))
        end
    end
    return lowest_at_xy
end

function simulate_step!(ground, bricks, maxx, maxy)
    lowest_at_xy = lowest_bricks(bricks, maxx, maxy)
    bottom_bricks = filter(x -> none_below(x, lowest_at_xy), bricks)
    remaining_bricks = filter(x -> !none_below(x, lowest_at_xy), bricks)
    stopped_bricks = []
    moved_table = Set()
    while length(bottom_bricks) > 0
        moved, stopped = fall!(ground, bottom_bricks)
        for b in moved
            push!(moved_table, b.id)
        end
        push!(stopped_bricks, stopped...)
        push!(remaining_bricks, moved...)
        lowest_at_xy = lowest_bricks(remaining_bricks, maxx, maxy)
        bottom_bricks = filter(x -> none_below(x, lowest_at_xy), remaining_bricks)
        remaining_bricks = filter(x -> !none_below(x, lowest_at_xy), remaining_bricks)
    end
    return stopped_bricks, length(moved_table)
end

function do_the_thing!(bricks)
    maxx = maximum(max(b.start[1], b.stop[1]) for b in bricks) + 1
    maxy = maximum(max(b.start[2], b.stop[2]) for b in bricks) + 1
    ground = zeros(Int, maxy, maxx)
    move_count = 1
    while move_count > 0
        bricks, move_count = simulate_step!(ground, bricks, maxx, maxy)
    end

    safe = 0
    chain_reaction = 0

    for i in eachindex(bricks)
        newground = zeros(Int, maxx+1, maxy+1)
        new_bricks = vcat(deepcopy(bricks[1:i-1]), deepcopy(bricks[i+1:end]))
        _, moved = simulate_step!(newground, new_bricks, maxx, maxy)
        safe += moved == 0 ? 1 : 0
        chain_reaction += moved
    end

    return safe, chain_reaction
end

function main()
    input = readlines("day22/input.txt")
    bricks = [parseline(line, i) for (i, line) in enumerate(input)]
    p1, p2 = do_the_thing!(bricks)
    println("Part 1: ", p1, "\nPart 2: ", p2)
end

main()
