
get_sources(g::AbstractGraph{T}) where T <: Integer = vertices(g)[indegree(g) .== 0]
get_sinks(g::AbstractGraph{T})  where T <: Integer = vertices(g)[outdegree(g) .== 0]

function add_source_target!(g::AbstractGraph{T}) where T <: Integer
    sinks = get_sinks(g)
    sources = get_sources(g)

    add_vertex!(g)
    for source in sources
        add_edge!(g, vertices(g)[end], source)
    end

    add_vertex!(g)
    for sink in sinks
        add_edge!(g, sink, vertices(g)[end])
    end
end

function N⁻(g::LightGraphs.SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[1]] = 1.0
    for v in vseqt
        nb = outneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

function N⁺(g::LightGraphs.SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[nV]] = 1.0
    for v in reverse(vseqt)
        nb = inneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

function weights_spc(g::AbstractGraph{T}; normalize = false) where T <: Integer
    g = LightGraphs.SimpleDiGraph(g)
    add_source_target!(g)
    vseqt = LightGraphs.Traversals.topological_sort(g)

    st = vseqt[[1, end]]
    N_m = N⁻(g, vseqt)
    N_p = N⁺(g, vseqt)
    tf = N_p[st[1]]
    idx = [!(v in st) for v in vertices(g)]

    rem_vertices!(g, st)
    N_m = N_m[idx]
    N_p = N_p[idx]
    vw = N_m .* N_p
    ew = zeros(ne(g))

    for (i, e) in enumerate(edges(g))
        ew[i] = N_m[src(e)] * N_p[dst(e)]
    end

    normalize && return (edgeweights = ew ./ tf, vertexweights = vw ./ tf, totalflow = tf)
    return (edgeweights = ew, vertexweights = vw, totalflow = tf)
end

function weights_matrix(g::AbstractGraph{T}, weights::AbstractVector{U}) where T <: Integer where U <: Real
    senders = [src(e) for e in edges(g)]
    receivers = [dst(e) for e in edges(g)]
    return sparse(senders, receivers, weights)
end
