using Distributed
addprocs((Sys.CPU_THREADS)-2-nprocs())
@everywhere using minimalFreezingExample
using Test

@testset "minimalFreezingExample.jl" begin
    @test size(createFFTPlans(2, [(200, 30, 10), (200, 30, 10), (200, 30, 10), (200, 30, 10)])) == (5, 2)
    println("second one made it")
end
