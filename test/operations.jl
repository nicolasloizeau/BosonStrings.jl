


@testset "Operations" begin
    o1 = Operator(1)
    o1 += 1, (1, 1, 1)
    o2 = Operator(1)
    o2 += 1, (1, 2, 2)
    o = o1 * o2
    o3 = Operator(1)
    o3 += 1, (1, 3, 3)
    o3 += 2, (1, 2, 2)
    @test equal(o, o3)
    o = rand_operator(1, 4, 10)
    o2 = o*o
    odense = op_to_dense(o, 100)
    o2dense = op_to_dense(o2, 100)
    @test abs(inner(5, o2, 5)-inner(5, o2dense, 5)) < 1e-10
    @test abs(inner(5, o2, 5)-inner(5, odense*odense, 5)) < 1e-10
end
