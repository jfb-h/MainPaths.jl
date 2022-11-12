_get_nbfun(::MainPathEdgeWeight) = emax_neighbors
_get_nbfun(::MainPathVertexWeight) = vmax_neighbors

function add_edges_from_children!(g, children)
    for (v, us) in enumerate(children)
        for u in us
            u == v && continue
            add_edge!(g, u, v)
        end
    end
    g
end

function add_edges_from_parents!(g, parents)
    for (v, us) in enumerate(parents)
        for u in us
            u == v && continue
            add_edge!(g, v, u)
        end
    end
    g
end

abstract type MainPathTraversal end

"""
    ForwardBackwardLocal(start)
Struct representing a main path traversal in both directions of the 
input DAG, starting at `start`.
"""
struct ForwardBackwardLocal{T} <: MainPathTraversal
    start::Vector{T}
end

function (x::ForwardBackwardLocal)(g, weight)
    nbfun = _get_nbfun(weight)
    w = weight(g)
    children = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))
    parents  = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))
    mp = SimpleDiGraph(nv(g))
    add_edges_from_children!(mp, children)
    add_edges_from_parents!(mp, parents)
    mp
end

"""
    ForwardLocal(start)
Struct representing a main path traversal against the edge direction of the 
input DAG, starting at `start`.
"""
struct ForwardLocal{T} <: MainPathTraversal
    start::Vector{T}
end

function (x::ForwardLocal)(g, weights)
    nbfun = _get_nbfun(weights)
    w = weights(g)
    children = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))
    mp = SimpleDiGraph(nv(g))
    add_edges_from_children!(mp, children)
    mp
end

"""
    BackwardLocal(start)
Struct representing a main path traversal following the edge direction of the 
input DAG, starting at `start`.
"""
struct BackwardLocal{T} <: MainPathTraversal
    start::Vector{T}
end

function (x::BackwardLocal)(g, weights)
    nbfun = _get_nbfun(weights)
    w = weights(g)
    parents = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))
    mp = SimpleDiGraph(nv(g))
    add_edges_from_parents!(mp, parents)
    mp
end
