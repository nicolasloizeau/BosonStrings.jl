using BosonStrings
include("random.jl")

Random.seed!(4)

n = 5
m = 5

o = rand_operator(1, 4, 10)
o = o*o



println(inner(n,o,m))

o = op_to_dense(o, 40)
println(inner(n,o,m))
