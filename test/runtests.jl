using MainPaths
using Test
using LightGraphs
using SparseArrays

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
]

function directed_star_graph(N)
    g = SimpleDiGraph(N)
    for target in 2:N
        add_edge!(g, 1, target)
    end
    g
end

# function plot_testgraph(g; eweights=nothing, vweights=nothing)
#     x = [1,1,2,2,4,4,4,5,5,5,3]
#     y = [1,3,2,4,2,3,1,1,3,4,5]
#     layoutfun(g) = Point.(zip(x, y))
    
#     nlabel = string.(1:nv(g)) 
#     elabel = string.(1:ne(g)) 
#     isnothing(vweights) || (nlabel = nlabel .* " : " .* string.(vweights))
#     isnothing(eweights) || (elabel = elabel .* " : " .* string.(eweights))
    
#     graphplot(g, layout=layoutfun, nlabels=nlabel, elabels=elabel,
#               nlabels_textsize=12, elabels_textsize=12,
#               nlabels_color=:blue, elabels_color=:red)
# end

testgraph = LightGraphs.SimpleDiGraph(A)

ew_spc, vw_spc, tf_spc = MainPaths.weights_spc(testgraph, normalize=false)

@testset "utils" begin
    vweights = [1,2,3,4,5]
    eweights = sparse([1,1,1,1], [2,3,4,5], [4,4,2,1])
    g = directed_star_graph(5)
    
    @test MainPaths.vmax_outneighbors(g, 1, vweights) == [5]
    @test MainPaths.emax_outneighbors(g, 1, eweights) == [2, 3]
    
    @test MainPaths.vmax_inneighbors(g, 1, vweights) == []
    @test MainPaths.emax_inneighbors(g, 1, eweights) == []
    
    @test MainPaths.vmax_inneighbors(g, 2, vweights) == [1]
    @test MainPaths.emax_inneighbors(g, 3, eweights) == [1]

    ew_sparse = MainPaths.weights_matrix(testgraph, ew_spc)
    @test length(ew_sparse.nzval) == length(ew_spc)

    parentsv, _ = MainPaths.bfs_multi(testgraph, 2, (g, v) -> MainPaths.vmax_outneighbors(g, v, vw_spc))
    @test parentsv == [[], [2], [2], [], [3], [], [], [], [5], [], []]
    parentse, _ = MainPaths.bfs_multi(testgraph, 2, (g, v) -> MainPaths.emax_outneighbors(g, v, ew_sparse))
    @test parentse == [[], [2], [], [2], [], [4], [], [], [6], [6], []]
end

@testset "SPC weights" begin
    ew_spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]
    vw_spc_true = [3, 7, 6, 4, 4, 2, 2, 2, 3, 2, 1]
    
    @test all(ew_spc .== ew_spc_true)
    @test all(vw_spc .== vw_spc_true)
    @test tf_spc == 10.0
end

@testset "genetic knowledge persistence" begin

end

@testset "FBMP" begin

end

@testset "GMP" begin

end