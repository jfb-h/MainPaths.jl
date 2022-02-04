
get_sources(g::AbstractGraph{T}) where T <: Integer = vertices(g)[indegree(g) .== 0]
get_sinks(g::AbstractGraph{T})  where T <: Integer = vertices(g)[outdegree(g) .== 0]

function add_source_target(g::AbstractGraph{T}) where T <: Integer
    o = deepcopy(g)
    sinks = get_sinks(o)
    sources = get_sources(o)

    add_vertex!(o)
    for source in sources
        add_edge!(o, vertices(o)[end], source)
    end

    add_vertex!(o)
    for sink in sinks
        add_edge!(o, sink, vertices(o)[end])
    end

    # add_edge!(o, vertices(o)[end], vertices(o)[end-1])
    
    return o
end

function extend_splc!(g)
    # This assumes standardform already, where the second to last vertex is the artificial source vertex.
    s = vertices(g)[end-1]
    for v in vertices(g)[1:end-2]
        add_edge!(g, s, v)
    end
    return g 
end

abstract type AbstractStandardForm end

struct StandardForm{T} <: AbstractStandardForm
    g::AbstractGraph{T}
end

struct StandardFormSPLC{T} <: AbstractStandardForm
    g::AbstractGraph{T}
end

standardize(g::AbstractGraph{T}, restype::Type{StandardForm}) where T <: Integer = restype(add_source_target(g))
standardize(g::AbstractGraph{T}, restype::Type{StandardFormSPLC}) where T <: Integer = restype(extend_splc!(add_source_target(g)))

function N⁻(g::Graphs.SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[1]] = 1.0
    for v in vseqt
        nb = outneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

function N⁺(g::Graphs.SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[nV]] = 1.0
    for v in reverse(vseqt)
        nb = inneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

function spc(c::AbstractStandardForm)
    g = c.g
    vt = Graphs.topological_sort_by_dfs(g)
    # st = vt[[1, end]]
    st = last(vertices(g), 2)
    Nm = N⁻(g, vt)
    Np = N⁺(g, vt)
    # i = findall(!in(st), vertices(g))
    return Nm[1:end-2], Np[1:end-2], Np[st[1]]
end

function vertexweights(c::AbstractStandardForm, normalize)
    Nm, Np, tf = spc(c)
    w = Nm .* Np
        
    if normalize == :none
        return w
    elseif normalize == :log
        return log.(w)
    else normalize == :totalflow
        return w /= tf
    end 
end

function edgeweights(g::AbstractGraph, c::AbstractStandardForm, normalize)
    Nm, Np, tf = spc(c)
        
    w = map(edges(g)) do e
        Nm[src(e)] * Np[dst(e)]
    end

    if normalize == :none
        w = w
    elseif normalize == :log
        w = log.(w)
    else normalize == :totalflow
        w = w /= tf
    end
    
    return sparseweights(g, w)
end


abstract type MainPathWeight end

abstract type MainPathEdgeWeight <: MainPathWeight end
abstract type MainPathVertexWeight <: MainPathWeight end


"""
    SPCEdge(normalize=:log)(g)

Struct representing Search Path Cout (SPC) edge weights, as defined in Batagelj (2003). 
`normalize=:totalflow` indicates that weights should be normalized relative to the 
total SPC flow, `normalize=:log` indicates that the logarithm of weights is returned. 
Set `normalize` to :none to indicate that weights should not be transformed.

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPCEdge <: MainPathEdgeWeight 
    normalize::Symbol = :log
end

(x::SPCEdge)(g) = edgeweights(g, standardize(g, StandardForm), x.normalize)

"""
    SPCVertex(normalize=:log)(g)

Struct representing Search Path Cout (SPC) vertex weights, as defined in Batagelj (2003). 
`normalize=:totalflow` indicates that weights should be normalized relative to the 
total SPC flow, `normalize=:log` indicates that the logarithm of weights is returned.
Set `normalize` to :none to indicate that weights should not be transformed.

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPCVertex <: MainPathVertexWeight 
    normalize::Symbol = :log
end

(x::SPCVertex)(g) = vertexweights(standardize(g, StandardForm), x.normalize)


"""
    SPLCEdge(normalize=:log)(g)

Struct representing Search Path Link Count edge weights, as defined in Batagelj (2003).
`normalize=:totalflow` indicates that weights should be normalized relative to the 
total SPLC flow, `normalize=:log` indicates that the logarithm of weights is returned.
Set `normalize` to :none to indicate that weights should not be transformed.

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPLCEdge <: MainPathVertexWeight
    normalize::Symbol = :log
end

(x::SPLCEdge)(g) = edgeweights(g, standardize(g, StandardFormSPLC), x.normalize)
"""
    SPLCVertex(normalize=:log)(g)

Struct representing Search Path Link Count vertex weights, as defined in Batagelj (2003).
`normalize=:totalflow` indicates that weights should be normalized relative to the 
total SPLC flow, `normalize=:log` indicates that the logarithm of weights is returned.
Set `normalize` to :none to indicate that weights should not be transformed.

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct SPLCVertex <: MainPathVertexWeight
    normalize::Symbol = :log
end

(x::SPLCVertex)(g) = vertexweights(standardize(g, StandardFormSPLC), x.normalize)
