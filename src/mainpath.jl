
abstract type MainPathAlgorithm end

function vmax_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractVector{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

function vmax_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractVector{U}) where {S,T <: Integer} where {U <: Real}  
    nb = inneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

function emax_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[v, nb]
    nb[wnb .== maximum(wnb)]
end

function emax_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = inneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb, v]
    nb[wnb .== maximum(wnb)]
end

# emax_outneighbors(g::AbstractMetaGraph, v::Integer) = emax_outneighbors(g, v, weights(g))
# emax_inneighbors(g::AbstractMetaGraph, v::Integer) = emax_inneighbors(g, v, weights(g))

function max_outweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) > 0 || return 0
    maximum(w[v, nb])
end

function max_inweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = inneighbors(g, v)
    length(nb) > 0 || return 0
    maximum(w[nb, v])
end


struct FBMP <: MainPathAlgorithm end

function bfs_multi(g::AbstractGraph{T}, source, neighborfn::Function) where T
    n = nv(g)
    visited = falses(n)
    parents = [Vector{T}() for _ in 1:n]
    cur_level = Vector{T}()
    sizehint!(cur_level, n)
    next_level = Vector{T}()
    sizehint!(next_level, n)
    @inbounds for s in source
        visited[s] = true
        push!(cur_level, s)
        parents[s] = [s]
    end
    while !isempty(cur_level)
        @inbounds for v in cur_level
            @inbounds @simd for i in neighborfn(g, v)
                if visited[i]
                    push!(parents[i], v)
                else
                    push!(next_level, i)
                    push!(parents[i], v)
                    visited[i] = true
                end
            end
        end
        empty!(cur_level)
        cur_level, next_level = next_level, cur_level
        sort!(cur_level)
    end
    return parents, visited
end

function mainpath(
    g::AbstractGraph{T}, 
    start::Vector{T}, 
    weights::Vector{<:Real},
    ::FBMP) where T <: Integer

    parents_fwd, visited_fwd = bfs_multi(g, start, (g, v) -> vmax_outneighbors(g, v, weights))
    parents_bwd, visited_bwd = bfs_multi(g, start, (g, v) -> vmax_inneighbors(g, v, weights))

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

    parents_fwd, visited_fwd = bfs_multi(g, start, (g, v) -> emax_outneighbors(g, v, weights))
    parents_bwd, visited_bwd = bfs_multi(g, start, (g, v) -> emax_inneighbors(g, v, weights))

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
