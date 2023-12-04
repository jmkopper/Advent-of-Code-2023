tokenize(nums) = [tryparse(Int, x) for x in split(nums, " ")] |> filter(x -> x !== nothing)

function scoreCard(row)
    s = split(split(row, ":")[2], "|")
    winning = Set(tokenize(s[1]))
    have = tokenize(s[2])
    return length([x for x in have if x in winning])
end

function part2(scores)
    copies = ones(Int, length(scores))
    for i in eachindex(scores)
        for j = 1:scores[i]
            copies[i+j] += copies[i]
        end
    end
    return sum(copies)
end

expScore(x) = x > 0 ? 2^(x - 1) : 0

function main()
    input = readlines("day4/input.txt")
    scores = [scoreCard(x) for x in input]
    println("Part 1: ", sum([expScore(x) for x in scores]))
    println("Part 2: ", part2(scores))
end

main()
