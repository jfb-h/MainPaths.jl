var documenterSearchIndex = {"docs":
[{"location":"#MainPaths.jl","page":"MainPaths.jl","title":"MainPaths.jl","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Welcome to MainPaths.jl, a Julia package for computing main paths built on top of the LightGraphs.jl graph library.","category":"page"},{"location":"#Getting-started","page":"MainPaths.jl","title":"Getting started","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"The package is currently not registered but can be added directly via the github package URL.","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"From the julia REPL, type ] to enter the Pkg REPL and run:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"pkg> add https://github.com/jfb-h/MainPaths.jl","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"To get started, you can then run:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":">julia using MainPaths","category":"page"},{"location":"#Example","page":"MainPaths.jl","title":"Example","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"As a showcase of the package's functionality, we compute the forward local main path based on SPC weights for the following simple example graph:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"using LightGraphs, MainPaths\n\nA = [\n 0  0  1  0  0  0  0  0  0  0  0\n 0  0  1  1  0  0  0  0  0  0  0\n 0  0  0  0  1  0  1  0  0  0  0\n 0  0  0  0  0  1  0  0  0  1  1\n 0  0  0  0  0  0  0  1  1  0  0\n 0  0  0  0  0  0  0  0  1  1  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n 0  0  0  0  0  0  0  0  0  0  0\n];\n\njulia> g = SimpleDiGraph(A)\n{11, 12} directed simple Int64 graph","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"As a first step, we then specify how to compute traversal weights:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> weight = SPCEdge(normalize=:none)\nSPCEdge(:none)","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"We then specify how we want to perform the main path traversal and at which vertices we want to start the traversal:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> start = [1,2];\n\njulia> traversal = ForwardLocal(start)\nForwardLocal{Int64}([1, 2])","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Now we can compute the main path:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> mp = mainpath(g, weight, traversal)\nMainpath with 9 vertices and 8 edges.","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"The mainpath function returns a MainPathResult, which just wraps a SimpleDiGraph representing the main path network, a vector indicating the indices of the main path vertices in the original graph, and a vector indicating the nodes at which the main path traversal was started:","category":"page"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"julia> mp.mainpath\n{9, 8} directed simple Int64 graph\n\njulia> mp.vertices\n9-element Vector{Int64}:\n  1\n  2\n  3\n  4\n  5\n  6\n  8\n  9\n 10\n\njulia> mp.start\n2-element Vector{Int64}:\n 1\n 2","category":"page"},{"location":"#API","page":"MainPaths.jl","title":"API","text":"","category":"section"},{"location":"","page":"MainPaths.jl","title":"MainPaths.jl","text":"Modules = [MainPaths]\nOrder   = [:function, :type]","category":"page"},{"location":"#MainPaths.bfs_multi-Union{Tuple{T}, Tuple{LightGraphs.AbstractGraph{T}, Any, Function}} where T","page":"MainPaths.jl","title":"MainPaths.bfs_multi","text":"bfs_multi(g, source, neighborfn)\n\nTraverse graph g via breadth-first search starting at vertices source and  choosing neighbors to visit according to neighborfn.\n\nThis is a modified breadth-first search traversal where instances of  a vertex being visited multiple times by different parents are recorded.  This function was modified from the LightGraphs bfs algorithm.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.edgeweights-Tuple{MainPaths.MainPathResult, AbstractMatrix{T} where T}","page":"MainPaths.jl","title":"MainPaths.edgeweights","text":"edgeweights(mp, w)\n\nReturn the weights of all edges in the mainpath mp from the weights matrix w containing traversal weights for the original graph.\n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.mainpath-Tuple{Any, MainPaths.MainPathWeight, MainPaths.MainPathTraversal}","page":"MainPaths.jl","title":"MainPaths.mainpath","text":"mainpath(g, weights, traversal)\n\nCompute the main path (or network of main paths) for graph g, utilizing edge/vertex weights  as specified by weights and performing main path traversal according to traversal. weights and traversal can be specified as any of the available MainPathWeight and MainPathTraversal  types, respectively. \n\n\n\n\n\n","category":"method"},{"location":"#MainPaths.BackwardLocal","page":"MainPaths.jl","title":"MainPaths.BackwardLocal","text":"BackwardLocal(start)\n\nStruct representing a main path traversal following the edge direction of the  input DAG, starting at start.\n\n\n\n\n\n","category":"type"},{"location":"#MainPaths.ForwardBackwardLocal","page":"MainPaths.jl","title":"MainPaths.ForwardBackwardLocal","text":"ForwardBackwardLocal(start)\n\nStruct representing a main path traversal in both directions of the  input DAG, starting at start.\n\n\n\n\n\n","category":"type"},{"location":"#MainPaths.ForwardLocal","page":"MainPaths.jl","title":"MainPaths.ForwardLocal","text":"ForwardLocal(start)\n\nStruct representing a main path traversal against the edge direction of the  input DAG, starting at start.\n\n\n\n\n\n","category":"type"},{"location":"#MainPaths.GKP","page":"MainPaths.jl","title":"MainPaths.GKP","text":"GKP(normalize=:none)(g)\n\nStruct representing Genetic Knowledge Persistence (GKP) vertex weights.    This is a modified version of the method proposed in Martinelli & Nomaler (2014)  where citations from future patents to patents before the curent layer are not ignored in the persistence computation.\n\nThe struct can be called to compute weights directly or can be passed to the mainpath function for dispatch.\n\n\n\n\n\n","category":"type"},{"location":"#MainPaths.SPCEdge","page":"MainPaths.jl","title":"MainPaths.SPCEdge","text":"SPCEdge(normalize=:log)(g)\n\nStruct representing Search Path Cout (SPC) edge weights, as defined in Batagelj (2003).  normalize=:totalflow indicates that weights should be normalized relative to the  total SPC flow, normalize=:log indicates that the logarithm of weights is returned.  Set normalize to :none to indicate that weights should not be transformed.\n\nThe struct can be called to compute weights directly or can be passed to the mainpath function for dispatch.\n\n\n\n\n\n","category":"type"},{"location":"#MainPaths.SPCVertex","page":"MainPaths.jl","title":"MainPaths.SPCVertex","text":"SPCVertex(normalize=:log)(g)\n\nStruct representing Search Path Cout (SPC) vertex weights, as defined in Batagelj (2003).  normalize=:totalflow indicates that weights should be normalized relative to the  total SPC flow, normalize=:log indicates that the logarithm of weights is returned. Set normalize to :none to indicate that weights should not be transformed.\n\nThe struct can be called to compute weights directly or can be passed to the mainpath function for dispatch.\n\n\n\n\n\n","category":"type"}]
}
