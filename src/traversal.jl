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
struct ForwardBackwardLocal{T<:Integer} <: MainPathTraversal
  start::Vector{T}
end

function (x::ForwardBackwardLocal)(g, w::AbstractSparseMatrix, weighttype::MainPathWeight)
  nbfun = _get_nbfun(weighttype)
  children = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))
  parents = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))
  mp = SimpleDiGraph(nv(g))
  add_edges_from_children!(mp, children)
  add_edges_from_parents!(mp, parents)
  mp
end
(x::ForwardBackwardLocal)(g, weights::MainPathWeight) = x(g, weights(g))

"""
    ForwardLocal(start)
Struct representing a main path traversal against the edge direction of the 
input DAG, starting at `start`.
"""
struct ForwardLocal{T<:Integer} <: MainPathTraversal
  start::Vector{T}
end

function (x::ForwardLocal)(g, w::AbstractSparseMatrix, weighttype::MainPathWeight)
  nbfun = _get_nbfun(weighttype)
  children = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, outneighbors))
  mp = SimpleDiGraph(nv(g))
  add_edges_from_children!(mp, children)
  mp
end
(x::ForwardLocal)(g, weights::MainPathWeight) = x(g, weights(g))

"""
    BackwardLocal(start)
Struct representing a main path traversal following the edge direction of the 
input DAG, starting at `start`.
"""
struct BackwardLocal{T<:Integer} <: MainPathTraversal
  start::Vector{T}
end

function (x::BackwardLocal)(g, w::AbstractSparseMatrix, weighttype::MainPathWeight)
  nbfun = _get_nbfun(weighttype)
  parents = bfs_multi(g, x.start, (g, v) -> nbfun(g, v, w, inneighbors))
  mp = SimpleDiGraph(nv(g))
  add_edges_from_parents!(mp, parents)
  mp
end
(x::BackwardLocal)(g, weights::MainPathWeight) = x(g, weights(g))
