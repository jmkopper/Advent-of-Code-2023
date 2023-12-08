function part1(nodes, start, stop, dirs)
    steps, loops = 0, 0
    m = length(dirs)
    current = start
    while current != stop
        if steps == m
            steps, loops = 0, loops + 1
        end
        i = steps + 1
        current = dirs[i] == "L" ? nodes[current][1] : nodes[current][2]
        steps += 1
    end
    return steps + loops * m
end

function part2(nodes, anodes, dirs)
    m, d = length(dirs), []
    for a in anodes
        current = a
        loops, steps = 0, 0
        while current[3] != 'Z'
            if steps == m
                steps, loops = 0, loops + 1
            end
            i = steps + 1
            current = dirs[i] == "L" ? nodes[current][1] : nodes[current][2]
            steps += 1
        end
        push!(d, loops + 1)
    end
    return lcm(d...) * m
end

function main()
    input = readlines("day8/input.txt")
    dirs = split(input[1], "")
    nodes = Dict(line[1:3] => (line[8:10], line[13:15]) for line in input[3:end])

    println("Part 1: ", part1(nodes, "AAA", "ZZZ", dirs))

    anodes = filter(n -> n[3] == 'A', keys(nodes)) |> collect
    x = part2(nodes, anodes, dirs)
    println("Part 2: ", x)
end

main()
