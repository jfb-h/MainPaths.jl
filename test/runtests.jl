using MainPaths
using Test
using LightGraphs

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

g = SimpleDiGraph(A)

ew_spc, vw_spc, tf_spc = MainPaths.weights_spc(g, normalize=false)


@testset "SPC weights" begin
    spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]
    @test all(ew_spc .== spc_true)
    @test tf_spc == 10.0
end

