module MainPaths
using Graphs
using SparseArrays

export mainpath
export SPCEdge, SPCVertex, GKP
export ForwardLocal, BackwardLocal, ForwardBackwardLocal

include("utils.jl")
include("weights_spc.jl")
include("weights_gkp.jl")
include("traversal.jl")
include("mainpath.jl")
include("segments.jl")

end
