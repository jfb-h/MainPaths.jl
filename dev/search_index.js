var documenterSearchIndex = {"docs":
[{"location":"#MainPaths.jl","page":"MainPaths.jl","title":"MainPaths.jl","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Welcome to MainPaths.jl, a Julia package for computing main paths built on top of the LightGraphs.jl graph library.","category":"page"},{"location":"#Getting-started","page":"MainPaths.jl","title":"Getting started","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"The package is currently not registered but can be added directly via the github package URL.","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"From the julia REPL, type ] to enter the Pkg REPL and run:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"pkg> add https://github.com/jfb-h/MainPaths.jl","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"To get started, you can then run:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":">julia using MainPaths","category":"page"},{"location":"#Example","page":"MainPaths.jl","title":"Example","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"As a showcase of the package's functionality, we compute the forward-backward main path based on SPC weights of a simple example graph:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"First, define the graph:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"using LightGraphs, MainPaths\n\nA = [\n 0  0  1  0  0  0  0  0  0  0  0\n 0  0  1  1  0  0  0  0  0  0  0\n 0  0  0  0  1  0  1  0  0  0  0\n 0  0  0  0  0  1  0  0  0  1  1\n 0  0  0  0  0  0  0  1  1  0  0\n 0  0  0  0  0  0  0  0  1  1  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n];\n\njulia> g = SimpleDiGraph(A)\n{11, 12} directed simple Int64 graph","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Then compute traversal weights:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> eweights, vweighs, flow = MainPaths.weights_spc(g, normalize=false);","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"And finally, compute the main path starting at nodes 1 and 2 (we here perform the main path traversal using edge weights, but vertex weights would also be possible):","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> start = [1, 2];\njulia> mp = mainpath(testgraph, start, eweights, FBMP())\nMainPath with 8 vertices and 9 edges.","category":"page"},{"location":"#API","page":"MainPaths.jl","title":"API","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Modules = [MainPaths]\nOrder   = [:function, :type]","category":"page"},{"location":"#MainPaths.bfs_multi-Union{Tuple{T}, Tuple{LightGraphs.AbstractGraph{T}, Any, Function}} where T","page":"MainPaths.jl","title":"MainPaths.bfs_multi","text":"bfs_multi(g, source, neighborfn)\n\nTraverse graph g via breadth-first search starting at vertices source and  choosing neighbors to visit according to neighborfn.\n\nThis is a modified breadth-first search traversal where instances of  a vertex being visited multiple times by different parents are recorded.  This function was modified from the LightGraphs bfs algorithm.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.emax_inneighbors-Union{Tuple{T}, Tuple{S}, Tuple{U}, Tuple{LightGraphs.AbstractGraph{T}, S, AbstractMatrix{U}}} where {U<:Real, S, T<:Integer}","page":"MainPaths.jl","title":"MainPaths.emax_inneighbors","text":"emax_inneighbors(g, v, w)\n\nObtain an array with the outneighbor(s) of vertex v that are connected with the  maximum weight edge in terms of edgeweight w. \n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.emax_outneighbors-Union{Tuple{T}, Tuple{S}, Tuple{U}, Tuple{LightGraphs.AbstractGraph{T}, S, AbstractMatrix{U}}} where {U<:Real, S, T<:Integer}","page":"MainPaths.jl","title":"MainPaths.emax_outneighbors","text":"emax_outneighbors(g, v, w)\n\nObtain an array with the outneighbor(s) of vertex v that are connected with the  maximum weight edge in terms of edgeweight w.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.mainpath-Union{Tuple{T}, Tuple{LightGraphs.AbstractGraph{T}, Vector{T}, AbstractMatrix{var\"#s4\"} where var\"#s4\"<:Real, FBMP}} where T<:Integer","page":"MainPaths.jl","title":"MainPaths.mainpath","text":"mainpath(g, start, weights::Matrix{<:Real}, FBMP())\n\nCompute the main path or main path network for graph g, traversing both forward and  backward starting at nodes start and using edge weights given as matrix weights  for neighbor selection during traversal.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.mainpath-Union{Tuple{T}, Tuple{LightGraphs.AbstractGraph{T}, Vector{T}, Vector{var\"#s18\"} where var\"#s18\"<:Real, FBMP}} where T<:Integer","page":"MainPaths.jl","title":"MainPaths.mainpath","text":"mainpath(g, start, weights::Vector{<:Real}, FBMP())\n\nCompute the main path or network of main paths for graph g, traversing both forward and  backward starting at nodes start and using node weights given as vector weights  for neighbor selection during traversal.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.vmax_inneighbors-Union{Tuple{T}, Tuple{S}, Tuple{U}, Tuple{LightGraphs.AbstractGraph{T}, S, AbstractVector{U}}} where {U<:Real, S, T<:Integer}","page":"MainPaths.jl","title":"MainPaths.vmax_inneighbors","text":"vmax_inneighbors(g, v, w)\n\nObtain an array with the inneighbor(s) of vertex v that score highest  in terms of vertex weights w.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.vmax_outneighbors-Union{Tuple{T}, Tuple{S}, Tuple{U}, Tuple{LightGraphs.AbstractGraph{T}, S, AbstractVector{U}}} where {U<:Real, S, T<:Integer}","page":"MainPaths.jl","title":"MainPaths.vmax_outneighbors","text":"vmax_outneighbors(g, v, w)\n\nObtain an array with the outneighbor(s) of vertex v that score highest  in terms of vertex weights w.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.weights_gkp-Union{Tuple{LightGraphs.AbstractGraph{T}}, Tuple{T}} where T<:Integer","page":"MainPaths.jl","title":"MainPaths.weights_gkp","text":"weights_gkp(g, normalize=:none)\n\nCompute the genetic knowledge persistence scores for all nodes in g. \n\nThis is a modified version of the method proposed in Martinelli & Nomaler (2014)  where citations from future patents to patents before the curent layer are not ignored in the persistence computation.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.weights_spc-Union{Tuple{LightGraphs.AbstractGraph{T}}, Tuple{T}} where T<:Integer","page":"MainPaths.jl","title":"MainPaths.weights_spc","text":"weights_spc(g, normalize=false)\n\nCompute the Search Path Count (SPC) weights for graph g as described in Batagelj (2003). The function returns a vector with edgeweights, a vector with vertex weights and the total flow. When normalize is set to true, edge weigths and vertex weights are divided by total flow.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.FBMP","page":"MainPaths.jl","title":"MainPaths.FBMP","text":"Struct representing a forward-backward main path traversal.  This doesn't contain any information but is used for dispatch in the mainpath() methods. \n\n\n\n\n\n","category":"type"}]
}
