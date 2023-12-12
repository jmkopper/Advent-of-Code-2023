function quickCountValid(pattern, counts, memo)
    if haskey(memo, (pattern, counts))
        return memo[pattern, counts]
    end
    if length(counts) == 0 # out of requirements
        return '#' in pattern ? 0 : 1
    end
    length(pattern) < sum(counts) && return 0 # too many requirements
    pattern[1] == '.' && return quickCountValid(pattern[2:end], counts, memo) # skip char
    
    n = 0
    if !('.' in pattern[1:counts[1]])
        if (length(pattern) > counts[1] && pattern[counts[1]+1] != '#') || length(pattern) == counts[1]
            n += quickCountValid(pattern[counts[1]+2:end], counts[2:end], memo) # place the segment and a dot
        end
    end
    
    m = pattern[1] == '?' ? quickCountValid(pattern[2:end], counts, memo) : 0 # place a dot
    
    memo[(pattern, counts)] = m + n
    return m + n
end

function part1(input)
    s = 0
    for row in input
        halves = split(row)
        line = halves[1]
        counts = parse.(Int, split(halves[2], ",")) |> Tuple
        s += quickCountValid(line, counts, Dict())
    end
    return s
end

function part2(input)
    s = 0
    for row in input
        halves = split(row)
        line = halves[1]
        counts = repeat(parse.(Int, split(halves[2], ",")), 5) |> Tuple
        repLine = repeat(line * '?', 5)[1:end-1]
        s += quickCountValid(repLine, counts, Dict())
    end
    return s
end

function main()
    input = readlines("day12/input.txt")
    println("Part 1: ", part1(input))
    println("Part 2: ", part2(input))
end

main()
