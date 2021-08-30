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

testgraph = LightGraphs.SimpleDiGraph(A)


@testset "utils" begin
    eweights = SPCEdge(:none)(testgraph)
    vweights = SPCVertex(:none)(testgraph)

    @test MainPaths.emax_neighbors(testgraph, 5, eweights, outneighbors) == [8, 9] 
    @test MainPaths.vmax_neighbors(testgraph, 9, vweights, inneighbors) == [5]

    parentsv = MainPaths.bfs_multi(testgraph, 2, (g, v) -> MainPaths.vmax_neighbors(g, v, vweights, outneighbors))
    parentse = MainPaths.bfs_multi(testgraph, [1,2], (g, v) -> MainPaths.emax_neighbors(g, v, eweights, outneighbors))
    
    @test parentsv == [[], [2], [2], [], [3], [], [], [], [5], [], []]
    @test parentse == [[1], [2], [1], [2], [3], [4], [], [5], [5,6], [6], []]
end

@testset "SPC" begin
    eweights = SPCEdge(:none)(testgraph)
    eweights_log = SPCEdge(:log)(testgraph)
    eweights_tf = SPCEdge(:totalflow)(testgraph)
    vweights = SPCVertex(:none)(testgraph)
    ew_spc_true = MainPaths.weights_matrix(testgraph, [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1])
    vw_spc_true = [3, 7, 6, 4, 4, 2, 2, 2, 3, 2, 1]
    Nm, Np, tf = MainPaths._weights_spc_raw(testgraph)

    @test size(ew_spc_true) == (nv(testgraph), nv(testgraph))
    @test all(eweights .== ew_spc_true)
    @test all(vweights .== vw_spc_true)
    @test tf == 10.0
    @test all(eweights_log.nzval .== log.(ew_spc_true.nzval))
    @test all(eweights_tf.nzval .== ew_spc_true.nzval / tf)
end

@testset "GKP" begin
    vw_gkp_true = [1.25, 3.75, 2.5, 2.5, 1.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    vw_gkp_none = GKP(:none)(testgraph)
    vw_gkp_local = GKP(:local)(testgraph)
    vw_gkp_global = GKP(:global)(testgraph)
    
    @test vw_gkp_none == vw_gkp_true
    @test vw_gkp_global == vw_gkp_true ./ maximum(vw_gkp_true)
    @test vw_gkp_local[2] == 1.0
    @test vw_gkp_local[1] == 1.25 / 3.75
end

@testset "mainpath" begin
    gkp = GKP(:none)
    spc = SPCEdge(:none)
    fwd = ForwardLocal([1,2])
    bwd = BackwardLocal([10])
    fbl = ForwardBackwardLocal([5])

    mp1 = mainpath(testgraph, gkp, fwd)
    mp2 = mainpath(testgraph, spc, fwd)
    mp3 = mainpath(testgraph, spc, bwd)
    mp4 = mainpath(testgraph, spc, fbl)
    
    @test mp1.vertices == [1,2,3,4,5,6,8,9,10]
    @test mp2.vertices == [1,2,3,4,5,6,8,9,10]
    @test mp3.vertices == [2,4,6,10]
    @test mp4.vertices == [1,2,3,5,8,9]
end
