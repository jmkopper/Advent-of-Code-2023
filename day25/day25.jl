function build_graph(lines)
    all_vertices = Set()
    vertices = []
    edges = Dict()
    for line in lines
        v, e = split(line, ": ")
        es = split(e)
        push!(vertices, v)
        push!(all_vertices, v, es...)
        edges[v] = es
    end
    A = zeros(Int, length(all_vertices), length(all_vertices))
    for (i, v) in enumerate(all_vertices)
        for (j, w) in enumerate(all_vertices)
            if haskey(edges, v) && w in edges[v]
                A[i, j] = 1
                A[j, i] = 1
            end
        end
    end

    return A
end

# Stoer-Wagner
function global_min_cut(A)
    mat = copy(A)
    best = (typemax(Int), [])
    n = size(mat, 1)
    co = [[i] for i in 1:n]

    for ph in 1:n-1
        w = mat[1, :]
        s, t = 1, 1
        for _ in 1:n-ph
            w[t] = typemin(Int)
            s, t = t, argmax(w)[1]
            w .+= mat[t, :]
        end

        c = w[t] - mat[t, t]
        if c < best[1]
            best = (c, co[t])
        end
        push!(co[s], co[t]...)
        mat[s, :] .+= mat[t, :]
        mat[:, s] = mat[s, :]
        mat[1, t] = typemin(Int)
    end
    return best
end

function main()
    lines = readlines("day25/input.txt")
    A = build_graph(lines)
    _, a = global_min_cut(A)
    println(length(a) * (size(A, 1)-length(a)))
end

main()
