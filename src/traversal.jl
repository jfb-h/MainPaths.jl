function _get_nbfun(weights)
    if weights isa MainPathEdgeWeight
        nbfun = emax_neighbors
    elseif weights isa MainPathVertexWeight
        nbfun = vmax_neighbors
    else
        error("Unknown weights type.")
    end

    nbfun
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

function (x::ForwardBackwardLocal)(g, weights)
    nbfun = _get_nbfun(weights)
    w = weights(g)

    parents_forward  = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))
    parents_backward = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))

    mp = SimpleDiGraph(nv(g))

    for (v, us) in enumerate(parents_forward)
        for u in us
            u == v && continue
            add_edge!(mp, u, v)
        end
    end

    for (v, us) in enumerate(parents_backward)
        for u in us
            u == v && continue
            add_edge!(mp, v, u)
        end
    end
    
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

    parents_forward  = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))

    mp = SimpleDiGraph(nv(g))

    for (v, us) in enumerate(parents_forward)
        for u in us
            u == v && continue 
            add_edge!(mp, u, v)
        end
    end

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

    parents_backward  = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))

    mp = SimpleDiGraph(nv(g))

    for (v, us) in enumerate(parents_backward)
        for u in us
            u == v && continue
            add_edge!(mp, v, u)
        end
    end

    mp
end
