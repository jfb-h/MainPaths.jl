module MainPaths
using LightGraphs
using SparseArrays

export mainpath
export FBMP

include("utils.jl")
include("weights_spc.jl")
include("weights_gkp.jl")
include("mainpath.jl")

end
