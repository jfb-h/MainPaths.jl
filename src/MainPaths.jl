module MainPaths
using LightGraphs
using SparseArrays

export mainpath
export FBMP

include("utils.jl")
include("spc_weights.jl")
include("genetic_knowper.jl")
include("mainpath.jl")

end
