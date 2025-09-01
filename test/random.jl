using BosonStrings
import BosonStrings as bs
using Random


function rand_operator(N, kmax, nterms)
    @assert N == 1
    o = Operator(N)
    for k in 1:nterms
        i = rand(1:kmax)
        j = rand(1:kmax)
        c = rand()-0.5 + (rand()-0.5)*im
        o += c, (1, i, j)
    end
    return o
end
