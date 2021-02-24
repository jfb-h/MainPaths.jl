module MainPaths
using LightGraphs
using SparseArrays

# using PlotlyJS
# using GraphPlot: stressmajorize_layout

export mainpath
export FBMP

include("mainpath.jl")
include("spc_weights.jl")
include("genetic_knowper.jl")
#include("plot.jl")

end
