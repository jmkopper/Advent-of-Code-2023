function readFile(filename)
    return open(filename) do f
        lines = read(f, String) |> strip |> x -> split(x, "\n")
        return lines
    end
end

function tokenize(nums)
    tokens, current = [], ""
    for char in nums
        if isspace(char) && current ≠ ""
            push!(tokens, tryparse(Int, current))
            current = ""
        elseif char != " "
            current *= char
        end
    end
    current != "" && push!(tokens, tryparse(Int, current))
    return tokens
end

function scoreCard(row)
    s = split(split(row, ":")[2], "|")
    winning = Set(tokenize(s[1]))
    have = tokenize(s[2])
    return length([x for x in have if x in winning])
end

function part2(scores)
    copies = [1 for _ in scores]
    for i in eachindex(scores)
        if scores[i] > 0
            for j = 1:scores[i]
                copies[i+j] += copies[i]
            end
        end
    end
    return sum(copies)
end

expScore(x) = x > 0 ? 2^(x - 1) : 0

function main()
    input = readFile("day4/input.txt")
    scores = [scoreCard(x) for x in input]
    println("Part 1: ", sum([expScore(x) for x in scores]))
    println("Part 2: ", part2(scores))
end

main()
