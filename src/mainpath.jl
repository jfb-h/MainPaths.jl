
abstract type MainPathAlgorithm end

struct MainPathResult{T}
    mainpath::SimpleDiGraph{T}
    vertices::Vector{T}
end

function Base.show(io::IO, mp::MainPathResult) 
    println(io, "MainPath with $(nv(mp.mainpath)) vertices and $(ne(mp.mainpath)) edges.")
end

"""
Struct representing a forward-backward main path traversal. 
This doesn't contain any information but is used for dispatch
in the `mainpath()` methods. 
"""
struct FBMP <: MainPathAlgorithm end

"""
    mainpath(g, start, weights::Vector{<:Real}, FBMP())

Compute the main path or network of main paths for graph `g`, traversing both forward and 
backward starting at nodes `start` and using node weights given as vector `weights` 
for neighbor selection during traversal.
"""
function mainpath(
    g::AbstractGraph{T}, 
    start::Vector{T}, 
    weights::Vector{<:Real},
    ::FBMP) where T <: Integer

    parents_fwd = bfs_multi(g, start, (g, v) -> vmax_outneighbors(g, v, weights))
    parents_bwd = bfs_multi(g, start, (g, v) -> vmax_inneighbors(g, v, weights))

    n = T(length(parents_fwd))
    mp = DiGraph{T}(n)

    for (v, us) in enumerate(parents_fwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(mp, u, v)
            end
        end
    end

    for (v, us) in enumerate(parents_bwd)
        @inbounds for u in us
            if u != v
                add_edge!(mp, v, u)
            end
        end
    end

    vs = findall(degree(mp) .> 0)
    mp, _ = induced_subgraph(mp, vs)
    
    return MainPathResult(mp, vs)
end

"""
    mainpath(g, start, weights::Matrix{<:Real}, FBMP())

Compute the main path or main path network for graph `g`, traversing both forward and 
backward starting at nodes `start` and using edge weights given as matrix `weights` 
for neighbor selection during traversal.
"""
function mainpath(
    g::AbstractGraph{T}, 
    start::Vector{T}, 
    weights::AbstractMatrix{<:Real},
    ::FBMP) where T <: Integer

    parents_fwd = bfs_multi(g, start, (g, v) -> emax_outneighbors(g, v, weights))
    parents_bwd = bfs_multi(g, start, (g, v) -> emax_inneighbors(g, v, weights))

    n = T(length(parents_fwd))
    mp = DiGraph{T}(n)

    for (v, us) in enumerate(parents_fwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(mp, u, v)
            end
        end
    end

    for (v, us) in enumerate(parents_bwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(mp, v, u)
            end
        end
    end

    vs = findall(degree(mp) .> 0)
    mp, _ = induced_subgraph(mp, vs)
    
    return MainPathResult(mp, vs)
end
