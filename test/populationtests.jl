@testset "Population" begin
    @test let
        pops = typeof(Population(15, 20, -10.0, 10.0))
        actual_type = typeof(Vector{Particle}(undef, 15))
        pops ≡ actual_type
    end
    @test let
        pops = typeof(Population(20, -10.0, 10.0))
        actual_type = typeof(Vector{Particle}(undef, 5))
        pops ≡ actual_type
    end
    @test_throws AssertionError Population(15, -1, 1.0, 1.0)
    @test_throws AssertionError Population(0, 5, 1.0, 1.0)
    @test_throws AssertionError Population(-1, 5, 1.0, 1.0)
end

@testset "Particle" begin
    @test_throws AssertionError Particle(zeros(3), zeros(2), zeros(1), 0.0, 0.0)
end
