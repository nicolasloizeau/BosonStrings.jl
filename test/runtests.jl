using BosonStrings
import BosonStrings as bs
using Test



@testset "SingleBoson io" begin
    @test bs.compress([-1, 1, -1, 1]) == [-1, 1, -1, 1]
    @test bs.compress([-2, -2, -1, 1]) == [-5, 1]
    @test bs.compress([-2, -2, -1, 1, 5, -6, -2, 8, -9, 1, 12]) == [-5, 6, -8, 8, -9, 13]
    @test bs.disp_single_string([-1, 3, 3]) == "(1)(†3)(†3)"
    @test bs.disp_single_string([-1, 3, 3, 1, -5, 1]) == "(1)(†3)(†3)(†1)(5)(†1)"
    @test bs.is_ordered([-1, 3, 3]) == false
    @test bs.is_ordered([-1, 3, 3, 1, -5, 1]) == false
    @test bs.is_ordered([5, -2, -1]) == true
    @test bs.is_ordered([-1]) == true
    @test bs.is_ordered([1]) == true
end


@testset "SingleBoson operations" begin
    O = bs.SingleBoson()
    O += 1, [-1, 1, -1, 1]
    O2 = bs.SingleBoson()
    O2 += 1, [0]
    O2 += 3, [1, -1]
    O2 += 1, [2, -2]
    @test O == O2
end
