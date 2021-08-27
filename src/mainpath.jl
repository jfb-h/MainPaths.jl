

struct MainPathResult{T}
    mainpath::SimpleDiGraph{T}
    vertices::Vector{T}
end

function Base.show(io::IO, mp::MainPathResult) 
    println(io, "MainPath with $(nv(mp.mainpath)) vertices and $(ne(mp.mainpath)) edges.")
end

"""
    mainpath(g, weights, traversal)

Compute the main path (or network of main paths) for graph g, utilizing edge/vertex weights 
as specified by `weights` and performing main path traversal according to `traversal`.
`weights` can be specified as any of the available `MainPathWeight` types and 
"""
function mainpath(g, weights::MainPathWeight, traversal::MainPathTraversal)
    mp = traversal(g, weights)
    MainPathResult(remove_isolates(mp)...)
end

