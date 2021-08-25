
abstract type MainPathAlgorithm end

struct FBMP <: MainPathAlgorithm end

function mainpath(
    g::AbstractGraph{T}, 
    start::Vector{T}, 
    weights::Vector{<:Real},
    ::FBMP) where T <: Integer

    parents_fwd = bfs_multi(g, start, (g, v) -> vmax_outneighbors(g, v, weights))
    parents_bwd = bfs_multi(g, start, (g, v) -> vmax_inneighbors(g, v, weights))

    n = T(length(parents_fwd))
    g = DiGraph{T}(n)

    for (v, us) in enumerate(parents_fwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(g, u, v)
            end
        end
    end

    for (v, us) in enumerate(parents_bwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(g, v, u)
            end
        end
    end

    return g
end

function mainpath(
    g::AbstractGraph{T}, 
    start::Vector{T}, 
    weights::AbstractMatrix{<:Real},
    ::FBMP) where T <: Integer

    parents_fwd = bfs_multi(g, start, (g, v) -> emax_outneighbors(g, v, weights))
    parents_bwd = bfs_multi(g, start, (g, v) -> emax_inneighbors(g, v, weights))

    n = T(length(parents_fwd))
    g = DiGraph{T}(n)

    for (v, us) in enumerate(parents_fwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(g, u, v)
            end
        end
    end

    for (v, us) in enumerate(parents_bwd)
        @inbounds for u in us
            if u != v #&& !has_edge(g, u, v)
                add_edge!(g, v, u)
            end
        end
    end

    return g
end
