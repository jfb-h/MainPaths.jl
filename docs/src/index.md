# MainPaths.jl

Welcome to MainPaths.jl, a Julia package for computing main paths built on top of the [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) graph library.

## Getting started

The package is currently not registered but can be added directly via the github package URL.

From the julia REPL, type `]` to enter the Pkg REPL and run:

```julia 
pkg> add https://github.com/jfb-h/MainPaths.jl
```

You can then run:

```julia
>julia using MainPaths
```

to get started.

## Example

As a showcase of the package's functionality, we compute the forward-backward main path based on SPC weight sof a simple
example graph:

First, define the graph:

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

Then compute traversal weights:

```julia
julia> eweights, vweighs, flow = MainPaths.weights_spc(g, normalize=false);
```
And finally, compute the main path starting at nodes `1` and `2` (we here perform the main path traversal using edge weights, but vertex weights would also be possible):

```julia
julia> start = [1, 2];
julia> mp = mainpath(testgraph, start, eweights, FBMP())
MainPath with 8 vertices and 9 edges.
```

## API

```@autodocs
Modules = [MainPaths]
Order   = [:function, :type]
```