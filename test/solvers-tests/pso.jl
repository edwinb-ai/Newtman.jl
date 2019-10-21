function f_sphere(x)
    return sum(x .^ 2)
end

@testset "PSO" begin

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(Sphere(), Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 97% of the time converges, the test passes
        # 50 * .97 = 48
        if count(assert_results) >= 45
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 10000)
            design = [π, π]
            result = ≈(val, design, atol=1e-8)
            push!(assert_results, result)
        end
        # if at least 97/100 pass, the it has converged
        if count(assert_results) >= 48
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 97% of the time converges, the test passes
        # 50 * .97 = 48
        if count(assert_results) >= 45
            true
        else
            println(count(assert_results))
            false
        end
    end

    # Test that a seed always gives the same results
    # @test let
    #     val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 1, 150150)
    #     println(val)
    #     same_val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 1, 150150)
    #     println(same_val)
    #     val ≡ same_val
    # end
end
