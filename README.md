# MainPaths
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jfb-h.github.io/MainPaths.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jfb-h.github.io/MainPaths.jl/dev)

*A package for computing main paths in the Julia programming language.*

**THIS PACKAGE IS IN AN EARLY STAGE AND MIGHT BREAK OR CHANGE WITHOUT WARNING**

## Installation

The package is currently not registered but can be added directly via the github package URL.
From the julia REPL, type `]` to enter the Pkg REPL and run:

```julia 
pkg> add https://github.com/jfb-h/MainPaths.jl

julia> using MainPaths
``` 

## Example

First, define an example graph:

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
```

Then, specify the main path weights and traversal algorithm and compute the main path:
```julia
julia> weight = SPCEdge(normalize=:none)
SPCEdge(:none)

julia> start = [1,2];

julia> traversal = ForwardLocal(start)
ForwardLocal{Int64}([1, 2])

julia> mainpath(g, weight, traversal)
MainPath with 9 vertices and 8 edges.
```

## Literature

[Batagelj (2003): Efficient Algorithms for Citation Networks. arXiv:cs/0309023](https://arxiv.org/abs/cs/0309023)


