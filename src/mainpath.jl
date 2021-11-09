struct MainPathResult{T}
    mainpath::SimpleDiGraph{T}
    vertices::Vector{T}
    start::Vector{T}
end

function Base.show(io::IO, mp::MainPathResult) 
    println(io, "MainPath with $(nv(mp.mainpath)) vertices and $(ne(mp.mainpath)) edges.")
end

"""
    mainpath(g, weights, traversal)

Compute the main path (or network of main paths) for graph g, utilizing edge/vertex weights 
as specified by `weights` and performing main path traversal according to `traversal`.
`weights` and `traversal` can be specified as any of the available `MainPathWeight` and `MainPathTraversal` 
types, respectively. 
"""
function mainpath(g, weights::MainPathWeight, traversal::MainPathTraversal)
    mp = traversal(g, weights)
    mp, vs = remove_isolates(mp)
    s = Set(traversal.start)
    start = findall(v -> v in s, vs)
    MainPathResult(mp, vs, start)
end

Graphs.nv(mp::MainPathResult) = nv(mp.mainpath)
Graphs.ne(mp::MainPathResult) = ne(mp.mainpath)

"""
    edgeweights(mp, w)

Return the weights of all edges in the mainpath `mp` from the weights matrix `w` containing
traversal weights for the original graph.
"""
function edgeweights(mp::MainPathResult, w::AbstractMatrix)
    map(edges(mp.mainpath)) do e
        s = mp.vertices[src(e)]
        d = mp.vertices[dst(e)]
        w[s, d]
    end
end
