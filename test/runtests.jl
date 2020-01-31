using Distributed
addprocs((Sys.CPU_THREADS)-2-nprocs())
@everywhere using minimalFreezingExample
using Test

@testset "minimalFreezingExample.jl" begin
    @test size(createSeveralRemotes(5, (200, 30, 10))) == (5, 5)
    println("first one fine")
    @test size(createFFTPlans(2, [1,2,3], [(200, 30, 10), (200, 30, 10), (200, 30, 10), (200, 30, 10)])) == (5, 5)
    println("second one made it")
end
