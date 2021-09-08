function remove_isolates(g)
    vs = findall(degree(g) .> 0)
    induced_subgraph(g, vs)
end

function vmax_neighbors(g, v, w, nbfun)
    nb = nbfun(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

function emax_neighbors(g, v, w, nbfun)
    nb = nbfun(g, v)
    length(nb) == 0 && return nb
    if nbfun == inneighbors
        wnb = w[nb, v]
    else
        wnb = w[v, nb]
    end      
    nb[wnb .== maximum(wnb)]
end

"""
    bfs_multi(g, source, neighborfn)

Traverse graph `g` via breadth-first search starting at vertices `source` and 
choosing neighbors to visit according to `neighborfn`.


This is a modified breadth-first search traversal where instances of 
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

"""
    meanweight(mp, w)

Compute the mean weight of the edges in main path `mp` as contained
in the weights matrix `w`, as computed from the original graph which
the main path was extracted from. 
"""
function meanweight(mp::MainPathResult, w::AbstractMatrix)
    res = 0.0
    for e in edges(mp.mainpath)
        s = mp.vertices[src(e)]
        d = mp.vertices[dst(e)]
        res += w[s, d]
    end

    res / ne(mp)
end

