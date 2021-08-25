"""
    vmax_outneighbors(g, v, w)

Obtain an array with the outneighbor(s) of vertex `v` that score highest 
in terms of vertex weights `w`.
"""
function vmax_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractVector{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

"""
    vmax_inneighbors(g, v, w)

Obtain an array with the inneighbor(s) of vertex `v` that score highest 
in terms of vertex weights `w`.
"""
function vmax_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractVector{U}) where {S,T <: Integer} where {U <: Real}  
    nb = inneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

"""
    emax_outneighbors(g, v, w)

Obtain an array with the outneighbor(s) of vertex `v` that are connected with the 
maximum weight edge in terms of edgeweight `w`.
"""
function emax_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[v, nb]
    nb[wnb .== maximum(wnb)]
end

"""
    emax_inneighbors(g, v, w)

Obtain an array with the outneighbor(s) of vertex `v` that are connected with the 
maximum weight edge in terms of edgeweight `w`. 
"""
function emax_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = inneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb, v]
    nb[wnb .== maximum(wnb)]
end


"""
    bfs_multi(g, source, neighborfn)

Traverse graph `g` starting at vertices `source` and choosing neighbors 
to visit according to `neighborfn`.


This is a modified breadth-first search traversal algorithm where instances of 
a vertex being visited multiple times by different parents are recorded. 
This function was modified from the LightGraphs bfs algorithm.
"""
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
    return parents
end
