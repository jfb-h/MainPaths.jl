
function _gkp_global(g::AbstractGraph{T}) where T <: Integer
    n = nv(g)
    sinks = get_sinks(g)
    sources = get_sources(g)
    source_idx = falses(n)
    source_idx[sources] .= true    
    visited = falses(n)
    visited[sinks] .= true

    w = 1 ./ indegree(g)
    od = outdegree(g)
    kp = zeros(n)
    kp[sinks] .= 1.0

    layer = sinks
    while length(layer) > 0
        new = T[]
        
        for v in layer
            inb = inneighbors(g, v)

            for nb in inb
                kp[nb] += w[v] * kp[v]
                od[nb] -= 1

                if !source_idx[nb] && od[nb] == 0
                    if !visited[nb] 
                        push!(new, nb)
                        visited[nb] = true
                    end
                end
            end 
        end
        layer = new
    end

    kp[sinks] .= 0
    return kp
end 


function _gkp_local(g::AbstractGraph{T}) where T <: Integer
    n = nv(g)
    sinks = get_sinks(g)
    sources = get_sources(g)
    source_idx = falses(n)
    source_idx[sources] .= true    
    visited = falses(n)
    visited[sinks] .= true
    l = zeros(Int, n)
    l[sinks] .= 1

    w = 1 ./ indegree(g)
    od = outdegree(g)
    kp = zeros(n)
    kp[sinks] .= 1.0

    layer = sinks; lnum = 1
    while length(layer) > 0
        new = T[]
        
        for v in layer
            inb = inneighbors(g, v)
            l[v] = lnum

            for nb in inb
                kp[nb] += w[v] * kp[v]
                od[nb] -= 1

                if !source_idx[nb] && od[nb] == 0
                    if !visited[nb] 
                        push!(new, nb)
                        visited[nb] = true
                    end
                end
            end 
        end
        layer = new; lnum += 1
    end

    l[sources] .= lnum
    kp[sinks] .= 0.0
    return kp, l

end 


"""
    GKP(normalize=:none)(g)

Struct representing Genetic Knowledge Persistence (GKP) vertex weights.   
This is a modified version of the method proposed in Martinelli & Nomaler (2014) 
where citations from future patents to patents before the curent layer are not ignored
in the persistence computation.

The struct can be called to compute weights directly or
can be passed to the `mainpath` function for dispatch.
"""
Base.@kwdef struct GKP <: MainPathVertexWeight 
    normalize::Symbol = :none
end

function (x::GKP)(g)
    if x.normalize == :global 
        res = _gkp_global(g)
        return res ./ maximum(res)
    elseif x.normalize == :local
        res, layers = _gkp_local(g)
        for l in unique(layers)
            res[layers .== l] .= res[layers .== l] ./ maximum(res[layers .== l])
        end
        res[isnan.(res)] .= 0.0
        return res
    elseif x.normalize == :none
        return _gkp_global(g)
    else
        throw(ArgumentError("Viable options for normalize are :global, :local or :none."))
    end
end  


