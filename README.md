# MainPaths
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jfb-h.github.io/MainPaths.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jfb-h.github.io/MainPaths.jl/dev)
[![Build Status](https://github.com/jfb-h/MainPaths.jl/workflows/CI/badge.svg)](https://github.com/jfb-h/MainPaths.jl/actions)
[![Coverage](https://codecov.io/gh/jfb-h/MainPaths.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jfb-h/MainPaths.jl)

*A package for computing main paths in the Julia programming language.*

## Installation

The package is currently not registered but can be added via github link.
From the julia REPL, type `]` to enter the Pkg REPL and run:

```julia 
pkg> add https://github.com/jfb-h/MainPaths.jl

julia> using MainPaths
``` 

## Example

```julia

using LightGraphs, MainPaths

A = [
 0  0  1  0  0  0  0  0  0  0  0
 0  0  1  1  0  0  0  0  0  0  0
 0  0  0  0  1  0  1  0  0  0  0
 0  0  0  0  0  1  0  0  0  1  1
 0  0  0  0  0  0  0  1  1  0  0
 0  0  0  0  0  0  0  0  1  1  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
];

julia> g = SimpleDiGraph(A)
{11, 12} directed simple Int64 graph

julia> eweights, vweighs, flow = MainPaths.spc_weights(g, normalize=false);

julia> mp = mainpath(testgraph, [1,2], eweights, :FBMP())
MainPath with 8 vertices and 9 edges.
```



