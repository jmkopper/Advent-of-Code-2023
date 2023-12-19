const XMAS = Dict("x" => 1, "m" => 2, "a" => 3, "s" => 4)

parse_part(str) = Tuple([(parse(Int, v) for (_, v) in split(strip(str, ['{', '}']), ',') |> x -> split.(x, '='))]...)
parse_workflows(str) = (split(strip(line, '}'), '{') for line in split(str, "\n")) |> Dict
lt(x, y) = x < y
gt(x, y) = x > y


score_pair(p, q) = prod(max(1 + q[i] - p[i], 0) for i in eachindex(q))
newtuple(old, idx, val) = Tuple(i == idx ? val : old[i] for i in eachindex(old))

function run_workflow(w, p)
    rules = split(w, ',')
    for rule in rules
        if !('>' in rule || '<' in rule)
            return rule
        end
        sym = '>' in rule ? '>' : '<'
        op = sym == '>' ? gt : lt
        halves = split(rule, ':')
        field, val = split(halves[1], sym)
        if op(p[XMAS[field]], parse(Int, val))
            return halves[2]
        end
    end
end

function get_neighbors(w)
    rules = split(w, ',')
    ns = []
    for rule in rules
        if !('>' in rule || '<' in rule)
            push!(ns, (rule, nothing, nothing, nothing))
            continue
        end
        sym = '>' in rule ? '>' : '<'
        halves = split(rule, ':')
        field, val = split(halves[1], sym)
        push!(ns, (halves[2], XMAS[field], sym, parse(Int, val)))
    end
    return ns
end

function part1(workflows, parts)
    accepted = 0
    for p in parts
        w = workflows["in"]
        n = run_workflow(w, p)
        while n != "R" && n != "A"
            n = run_workflow(workflows[n], p)
        end
        accepted += n == "A" ? sum(p) : 0
    end
    return accepted
end

function part2(workflows)
    dists = Dict("in" => ((1, 1, 1, 1), (4000, 4000, 4000, 4000)))
    q = ["in"]
    # Notably, if we remove the "R" and "A" nodes,
    # then the workflows form a tree
    tot = 0
    while length(q) > 0
        w = popfirst!(q)
        nextmin, nextmax = dists[w]
        for (next_workflow, idx, sym, val) in get_neighbors(workflows[w])
            newmin, newmax = nextmin, nextmax
            if sym == '>'
                newmin = newtuple(newmin, idx, max(newmin[idx], val + 1))
                nextmax = newtuple(nextmax, idx, min(nextmax[idx], val))
            elseif sym == '<'
                newmax = newtuple(newmax, idx, min(newmax[idx], val - 1))
                nextmin = newtuple(nextmin, idx, max(nextmin[idx], val))
            end
            if next_workflow == "A"
                tot += score_pair(newmin, newmax)
            elseif next_workflow != "R"
                dists[next_workflow] = (newmin, newmax)
                push!(q, next_workflow)
            end
        end
    end
    return tot
end

function main()
    input = read("day19/input.txt", String) |> strip
    d = split(input, "\n\n")
    workflows = parse_workflows(d[1])
    parts = [parse_part(s) for s in split(d[2], "\n")]
    println(part1(workflows, parts))
    println(part2(workflows))
end

main()
