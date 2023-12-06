function countBetter(t, d)
    r1, r2 = floor(Int, (t - sqrt(t^2 - 4 * d)) / 2), floor(Int, (t + sqrt(t^2 - 4 * d)) / 2)
    intFix = (t - r1) * r1 == d || (t - r2) * r2 == d ? -1 : 0 # Not actually needed
    return abs(r1 - r2) + intFix
end

function main()
    input = readlines("day6/input.txt")
    times = (split(input[1], " ") .|> x -> tryparse(Int, x)) |> filter(!isnothing)
    distances = (split(input[2], " ") .|> x -> tryparse(Int, x)) |> filter(!isnothing)
    println("Part 1: ", prod(zip(times, distances) .|> x -> countBetter(x...)))
    t, d = parse(Int, join(string.(times))), parse(Int, join(string.(distances)))
    t = reduce((x, y) -> x * 10 + y, times)
    println("Part 2: ", countBetter(sum(t), sum(d)))
end

main()
