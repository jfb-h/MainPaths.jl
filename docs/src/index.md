# MainPaths.jl

Welcome to MainPaths.jl, a Julia package for computing main paths built on top of the [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) graph library.

## Getting started

The package is currently not registered but can be added directly via the github package URL.

From the julia REPL, type `]` to enter the Pkg REPL and run:

```julia 
pkg> add https://github.com/jfb-h/MainPaths.jl
```

To get started, you can then run:

```julia
>julia using MainPaths
```

## Example

As a showcase of the package's functionality, we compute the forward local main path based on SPC weights for the following simple example graph:

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
As a first step, we then specify how to compute traversal weights:

```julia
julia> weight = SPCEdge(normalize=:none)
SPCEdge(:none)
```
We then specify how we want to perform the main path traversal and at which vertices we want to start the traversal:

```julia
julia> start = [1,2];

julia> traversal = ForwardLocal(start)
ForwardLocal{Int64}([1, 2])
```
Now we can compute the main path:

```julia
julia> mp = mainpath(g, weight, traversal)
Mainpath with 9 vertices and 8 edges.
```
The `mainpath` function returns a `MainPathResult`, which just wraps a `SimpleDiGraph` representing the main path network, a vector indicating the indices of the main path vertices in the original graph, and a vector indicating the nodes at which the main path traversal was started:

```julia
julia> mp.mainpath
{9, 8} directed simple Int64 graph

julia> mp.vertices
9-element Vector{Int64}:
  1
  2
  3
  4
  5
  6
  8
  9
 10

julia> mp.start
2-element Vector{Int64}:
 1
 2
```

## API

```@autodocs
Modules = [MainPaths]
Order   = [:function, :type]
```