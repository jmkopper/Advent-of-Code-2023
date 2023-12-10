function firstDigit(line)
    indices = [findfirst(string(i), line) for i = 1:9]
    idx = minimum([x.start for x in indices[indices.!==nothing]])
    return tryparse(Int, line[idx:idx])
end

lastDigit(line) = reverse(line) |> firstDigit

DIGITS = Dict(string(i) => i for i = 1:9)
DIGITS["one"] = 1
DIGITS["two"] = 2
DIGITS["three"] = 3
DIGITS["four"] = 4
DIGITS["five"] = 5
DIGITS["six"] = 6
DIGITS["seven"] = 7
DIGITS["eight"] = 8
DIGITS["nine"] = 9

function firstDigitOrStr(line)
    indices =
        [(i, findfirst(i, line)) for i in keys(DIGITS)] |> filter(((x, y),) -> !isnothing(y))
    indices = Dict(k => v.start for (k, v) in indices)
    name = collect(keys(indices))[argmin(collect(values(indices)))]
    return DIGITS[name]
end

function lastDigitOrStr(line)
    pairs =
        [(i, findlast(i, line)) for i in keys(DIGITS)] |> filter(((x, y),) -> !isnothing(y))
    pairs = Dict(k => v.stop for (k, v) in pairs)
    name = collect(keys(pairs))[argmax(collect(values(pairs)))]
    return DIGITS[name]
end

function main()
    input = readlines("day1/input.txt")
    vals = [firstDigit(x) * 10 + lastDigit(x) for x in input]
    vals2 = [firstDigitOrStr(x) * 10 + lastDigitOrStr(x) for x in input]
    println(sum(vals))
    println(sum(vals2))
end

main()
