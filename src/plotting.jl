
function plot_mainpath(g::SimpleDiGraph, mp::MainPaths.MainPathResult; layout=GraphMakie.spring)
    vertexcolor = [v in Set(mp.vertices) ? :red : :black for v in 1:nv(g)] 
    vertexsize  = [v in Set(mp.vertices) ? 20 : 10 for v in 1:nv(g)] 
   
    mp_edges_mapped = map(edges(mp.mainpath)) do e
        LightGraphs.Edge(mp.vertices[src(e)], mp.vertices[dst(e)])
    end

    mp_edges_mapped = Set(mp_edges_mapped)

    edgeattrib = map(edges(g)) do e
        ind = e in mp_edges_mapped
        col = ind ? :red : :black
        wid = ind ? 5 : 1
        return col, wid
    end

    f, ax, p = graphplot(g, layout=GraphMakie.spring,
                node_color=vertexcolor, node_size=vertexsize,
                edge_color=[a[1] for a in edgeattrib],
                edge_width=[a[2] for a in edgeattrib])
    
    hidedecorations!(ax); hidespines!(ax)
    
    f
end


function plot_testgraph(g; eweights=nothing, vweights=nothing)
    x = [1,1,2,2,3,3,4,4,4,4,4]
    y = [2,4,2,4,2,3,1,2,3,4,5]
    layoutfun(g) = Point.(zip(x, y))

    !isnothing(eweights) && (eweights = [eweights[src(e), dst(e)] for e in edges(g)])
    
    nlabel = string.(1:nv(g)) 
    elabel = string.(1:ne(g)) 
    isnothing(vweights) || (nlabel = nlabel .* " : " .* string.(round.(vweights, digits=2)))
    isnothing(eweights) || (elabel = elabel .* " : " .* string.(round.(eweights, digits=2)))
    
    f, ax, p = graphplot(g, layout=layoutfun, nlabels=nlabel, elabels=elabel,
              nlabels_textsize=12, elabels_textsize=12,
              nlabels_color=:blue, elabels_color=:red,
              nlabels_align=(:center, :top), nlabels_distance=5,
              arrow_shift=.8)
    
    hidedecorations!(ax); hidespines!(ax)
    
    f
end


function plot_testgraph_mainpath(g, mp::MainPaths.MainPathResult; 
                                 eweights=nothing, vweights=nothing)
    
                                 x = [1,1,2,2,3,3,4,4,4,4,4]
    y = [2,4,2,4,2,3,1,2,3,4,5]
    layoutfun(g) = Point.(zip(x, y))

    !isnothing(eweights) && (eweights = [eweights[src(e), dst(e)] for e in edges(g)])
    
    nlabel = string.(1:nv(g)) 
    elabel = string.(1:ne(g)) 
    isnothing(vweights) || (nlabel = nlabel .* " : " .* string.(round.(vweights, digits=2)))
    isnothing(eweights) || (elabel = elabel .* " : " .* string.(round.(eweights, digits=2)))
    
    vertexcolor = [v in Set(mp.vertices) ? :red : :black for v in 1:nv(g)] 
    vertexsize  = [v in Set(mp.vertices) ? 15 : 10 for v in 1:nv(g)] 
   
    mp_edges_mapped = map(edges(mp.mainpath)) do e
        LightGraphs.Edge(mp.vertices[src(e)], mp.vertices[dst(e)])
    end

    mp_edges_mapped = Set(mp_edges_mapped)

    edgeattrib = map(edges(g)) do e
        ind = e in mp_edges_mapped
        col = ind ? :red : :black
        wid = ind ? 4 : 1
        return col, wid
    end

    f, ax, p = graphplot(g, layout=layoutfun,
              node_size=vertexsize, node_color=vertexcolor,
              edge_color=[a[1] for a in edgeattrib],
              edge_width=[a[2] for a in edgeattrib],
              nlabels=nlabel, elabels=elabel,
              nlabels_textsize=12, elabels_textsize=12,
              nlabels_color=:black, nlabels_distance=10,
              elabels_color=:black, elabels_distance=3,
              nlabels_align=(:center, :top), 
              arrow_shift=.8)
    
    hidedecorations!(ax); hidespines!(ax)
    
    f
end