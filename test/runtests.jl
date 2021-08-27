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

testgraph = LightGraphs.SimpleDiGraph(A)

ew_spc, vw_spc, tf_spc = MainPaths.weights_spc(testgraph, normalize=false)
vw_gkp = MainPaths.weights_gkp(testgraph)

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

    @test length(ew_spc.nzval) == 12

    parentsv = MainPaths.bfs_multi(testgraph, 2, (g, v) -> MainPaths.vmax_outneighbors(g, v, vw_spc))
    @test parentsv == [[], [2], [2], [], [3], [], [], [], [5], [], []]
    parentse = MainPaths.bfs_multi(testgraph, 2, (g, v) -> MainPaths.emax_outneighbors(g, v, ew_spc))
    @test parentse == [[], [2], [], [2], [], [4], [], [], [6], [6], []]
    parentsemult = MainPaths.bfs_multi(testgraph, [1,2], (g, v) -> MainPaths.emax_outneighbors(g, v, ew_spc))
    @test parentsemult == [[1], [2], [1], [2], [3], [4], [], [5], [5,6], [6], []]
end

@testset "SPC weights" begin
    ew_spc_true = MainPaths.weights_matrix(testgraph, [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1])
    vw_spc_true = [3, 7, 6, 4, 4, 2, 2, 2, 3, 2, 1]  
    @test all(ew_spc .== ew_spc_true)
    @test all(vw_spc .== vw_spc_true)
    @test tf_spc == 10.0
end

@testset "genetic knowledge persistence" begin
    vw_gkp_true = [1.25, 3.75, 2.5, 2.5, 1.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    vw_gkp_none = MainPaths.weights_gkp(testgraph, normalize=:none)
    vw_gkp_global = MainPaths.weights_gkp(testgraph, normalize=:global)
    vw_gkp_local = MainPaths.weights_gkp(testgraph, normalize=:local)
    @test vw_gkp_none == vw_gkp_true
    @test vw_gkp_global == vw_gkp_true ./ maximum(vw_gkp_true)
    @test vw_gkp_local[2] == 1.0
    @test vw_gkp_local[1] == 1.25 / 3.75
end

@testset "FBMP" begin
    mp_fbmp_gkp = mainpath(testgraph, [2], vw_gkp, FBMP())
    @test mp_fbmp_gkp.vertices == [2,3,4,5,6,8,9,10]
    @test ne(mp_fbmp_gkp.mainpath) == 8
    mp_fbmp_spc = mainpath(testgraph, [2], ew_spc, FBMP())
    @test mp_fbmp_spc.vertices == [2,4,6,9,10]
    @test ne(mp_fbmp_spc.mainpath) == 4
end
