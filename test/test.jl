using BosonStrings



o1 = Operator(1)
o1 += 1, (1, 1, 1)
o2 = Operator(1)
o2 += 1, (1, 2, 2)
o = o1 * o2
println(o)

println(inner(2,o,2))
