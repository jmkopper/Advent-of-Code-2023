function validDirs(graph, p)
    r, c = p
    nrow, ncol = length(graph), length(graph[1])
    m = graph[p[1]][p[2]]
    dirs = []
    goesup = ["|", "L", "J", "S"]
    goesleft = ["J", "-", "7", "S"]
    goesright = ["L", "-", "F", "S"]
    goesdown = ["|", "F", "7", "S"]
    if m == "|"
        (r > 1 && graph[r-1][c] in goesdown) && push!(dirs, (r - 1, c))
        (r < nrow && graph[r+1][c] in goesup) && push!(dirs, (r + 1, c))
    elseif m == "-"
        (c > 1 && graph[r][c-1] in goesright) && push!(dirs, (r, c - 1))
        (c < ncol && graph[r][c+1] in goesleft) && push!(dirs, (r, c + 1))
    elseif m == "L"
        (r > 1 && graph[r-1][c] in goesdown) && push!(dirs, (r - 1, c))
        (c < ncol && graph[r][c+1] in goesleft) && push!(dirs, (r, c + 1))
    elseif m == "J"
        (r > 1 && graph[r-1][c] in goesdown) && push!(dirs, (r - 1, c))
        (c > 1 && graph[r][c-1] in goesright) && push!(dirs, (r, c - 1))
    elseif m == "7"
        (r < nrow && graph[r+1][c] in goesup) && push!(dirs, (r + 1, c))
        (c > 1 && graph[r][c-1] in goesright) && push!(dirs, (r, c - 1))
    elseif m == "F"
        (r < nrow && graph[r+1][c] in goesup) && push!(dirs, (r + 1, c))
        (c < ncol && graph[r][c+1] in goesleft) && push!(dirs, (r, c + 1))
    elseif m == "S"
        (r > 1 && graph[r-1][c] in goesdown) && push!(dirs, (r - 1, c))
        (r < nrow && graph[r+1][c] in goesup) && push!(dirs, (r + 1, c))
        (c > 1 && graph[r][c-1] in goesright) && push!(dirs, (r, c - 1))
        (c < ncol && graph[r][c+1] in goesleft) && push!(dirs, (r, c + 1))
    end
    return dirs
end

function traverseLoop(graph, start, init)
    prev, current = start, init
    steps, stepCount = 0, Dict()
    while current != start
        t = current
        valid = validDirs(graph, current) |> filter(!=(prev))
        if length(valid) == 0
            return stepCount
        else
            steps += 1
            stepCount[current] = steps
            current = first(valid)
            prev = t
        end
    end
    stepCount[start] = 0
    return stepCount
end

startCoords(graph) = first(
    [(r, c) for r in eachindex(graph), c in eachindex(graph[1])] |> filter(t -> graph[t[1]][t[2]] == "S"),
)

function part1(graph)
    start = startCoords(graph)
    current = first(validDirs(graph, start))
    steps = traverseLoop(graph, start, current)
    totalSteps = maximum(values(steps))
    shortest = [min(s, totalSteps - s) for s in values(steps)]
    return maximum(shortest) + (totalSteps % 2)
end

isCrossing(graph, (r1, c1), (r2, c2), loopNodes) =
    !((r2, c2) in validDirs(graph, (r1, c1)) && (r1, c1) in validDirs(graph, (r2, c2)))

function part2(graph)
    start = startCoords(graph)
    current = first(validDirs(graph, start))
    loopNodes = traverseLoop(graph, start, current)
    count = 0

    for r = 2:length(graph), c = 1:length(graph[1])
        haskey(loopNodes, (r, c)) && continue

        crossings = 0
        x = r
        startChar = "Z"
        while x >= 1
            if haskey(loopNodes, (x, c)) && startChar == "Z"
                if graph[x][c] == "-"
                    crossings += 1
                else
                    startChar = graph[x][c]
                end
            elseif haskey(loopNodes, (x, c)) && !((x - 1, c) in validDirs(graph, (x, c)))
                stopChar = graph[x][c]
                if (startChar == "L" && stopChar == "7") ||
                   (startChar == "J" && stopChar == "F")
                    crossings += 1
                end
                startChar = "Z"
            end
            x -= 1
        end

        count += crossings % 2
    end
    return count
end

function main()
    graph = split.(readlines("day10/input.txt"), "")
    println("Part 1: ", part1(graph))
    println("Part 2: ", part2(graph))
end

main()
