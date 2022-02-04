module Experimental

using Graphs
using MainPaths: MainPathResult

function findbranchpoints(g)
	vs = findall(outdegree(g) .> 1)
	idx = map(vs) do v
		onb = outneighbors(g, v)
		any(outdegree(g, onb) .> 0) && return true
		return false
	end
	vs[idx]
end

function findmergepoints(g)
	vs = findall(indegree(g) .> 1)
	idx = map(vs) do v
		onb = inneighbors(g, v)
		any(indegree(g, onb) .> 0) && return true
		return false
	end
	vs[idx]
end

findjunctions(mp) = intersect(findmergepoints(mp), findbranchpoints(mp))


struct MainPathSegment{T}
    intermediates::Vector{T}
    startknot::T
    endknot::T
end

Base.length(seg::MainPathSegment) = length(seg.intermediates)


function _collect_segment(g::AbstractGraph{T}, v::T, nbfun, branchind, mergeind) where T <: Integer
    (branchind[v] || mergeind[v]) && return T[], v
    
    intermediates = T[]
    current = v

    while !(branchind[current] || mergeind[current])
        push!(intermediates, current)
        next = nbfun(g, current)
        
        if length(next) == 0
            return intermediates, 0
        elseif length(next) > 1
            append!(intermediates, next)
            return intermediates, 0
        elseif (branchind[next[1]] || mergeind[next[1]])
            return intermediates, next[1]
        end
        
        current = next[1]
    end
end

function segments(mp::MainPathResult)
    g = mp.mainpath
    brapoints = findbranchpoints(g)
    merpoints = findmergepoints(g)
    
    braind = falses(nv(g)); braind[brapoints] .= true
    merind = falses(nv(g)); merind[merpoints] .= true
    
    visited = falses(nv(g))
    segs = MainPathSegment[]

    for b in brapoints
        inb = inneighbors(g, b)
        onb = outneighbors(g, b)
        
        for i in inb
            isnothing(i) && break
            visited[i] && continue
            intermed, endpoint = _collect_segment(g, i, inneighbors, braind, merind)
            visited[intermed] .= true
            push!(segs, MainPathSegment(reverse(intermed), endpoint, b))
        end

        for o in onb
            isnothing(o) && break
            visited[o] && continue
            intermed, endpoint = _collect_segment(g, o, outneighbors, braind, merind)
            visited[intermed] .= true
            push!(segs, MainPathSegment(intermed, b, endpoint))
        end
    end

    for m in merpoints
        inb = inneighbors(g, m)
        onb = outneighbors(g, m)
        
        for i in inb
            isnothing(i) && break
            visited[i] && continue
            intermed, endpoint = _collect_segment(g, i, inneighbors, braind, merind)
            visited[intermed] .= true
            push!(segs, MainPathSegment(reverse(intermed), endpoint, m))
        end

        for o in onb
            isnothing(o) && break
            visited[o] && continue
            intermed, endpoint = _collect_segment(g, o, outneighbors, braind, merind)
            visited[intermed] .= true
            push!(segs, MainPathSegment(intermed, m, endpoint))
        end
    end

    segs
end


function meanweight(mp::MainPathResult, seg::MainPathSegment, w::AbstractMatrix)
    vs = seg.startknot == 0 ? seg.intermediates : vcat(seg.startknot, seg.intermediates)
    vs = seg.endknot == 0 ? vs : vcat(vs, seg.endknot) 

    path, pvs = induced_subgraph(mp.mainpath, vs)
    res = 0.0
    for e in edges(path)
        s = pvs[src(e)]; d = pvs[dst(e)]
        res += w[mp.vertices[s], mp.vertices[d]]
    end

    res / ne(path)
end

end