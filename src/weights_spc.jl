
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

function weights_matrix(g::AbstractGraph{T}, weights::AbstractVector{U}) where T <: Integer where U <: Real
    senders = [src(e) for e in edges(g)]
    receivers = [dst(e) for e in edges(g)]
    return sparse(senders, receivers, weights, nv(g), nv(g))
end

function _weights_spc_raw(g::AbstractGraph{T}) where T <: Integer
    g = LightGraphs.SimpleDiGraph(g)
    add_source_target!(g)
    vseqt = LightGraphs.topological_sort_by_dfs(g)
    st = vseqt[[1, end]]
    N_m = N⁻(g, vseqt)
    N_p = N⁺(g, vseqt)
    idx = [!(v in st) for v in vertices(g)]
    rem_vertices!(g, st)
    N_m[idx], N_p[idx], N_p[st[1]]
end

function _weights_spc_vertices(g, normalize)
    N_m, N_p, tf = _weights_spc_raw(g)
    vw = N_m .* N_p
    normalize && (vw /= tf)
    vw
end

function _weights_spc_edges(g, normalize)
    N_m, N_p, tf = _weights_spc_raw(g)
    
    ew = map(edges(g)) do e
        N_m[src(e)] * N_p[dst(e)]
    end

    normalize && (ew /= tf)
    weights_matrix(g, ew)
end


abstract type MainPathWeight end

abstract type MainPathEdgeWeight <: MainPathWeight end
abstract type MainPathVertexWeight <: MainPathWeight end


"""
    SPCEdge(normalize=false)(g)

Struct representing Search Path Cout (SPC) edge weights, as defined in Batagelj (2003). 
The argument `normalize` indicates whether weights should be normalized relative to the 
total SPC flow. 

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPCEdge <: MainPathEdgeWeight 
    normalize::Bool = false
end

(x::SPCEdge)(g) = _weights_spc_edges(g, x.normalize)

"""
    SPCVertex(normalize=false)(g)

Struct representing Search Path Cout (SPC) vertex weights, as defined in Batagelj (2003). 
The argument `normalize` indicates whether weights should be normalized relative to the 
total SPC flow. The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPCVertex <: MainPathVertexWeight 
    normalize::Bool = false
end

(x::SPCVertex)(g) = _weights_spc_vertices(g, x.normalize)