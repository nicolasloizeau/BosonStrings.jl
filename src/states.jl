

function inner(n::Int, v1::Int, v2::Int, m::Int)
    if (n - v1 >= 0 && m - v2 >= 0) && (n - v1 == m - v2)
        return sqrt(factorial(n) / factorial(n - v1) * factorial(m) / factorial(m - v2))
    end
    return 0
end

function inner(n::Int, string::BosonString{1}, m::Int)
    i = Int(string.v[1])
    j = Int(string.v[2])
    return inner(n, i, j, m)
end

function inner(n::Vector{Int}, string::BosonString, m::Vector{Int})
    res = 1
    N = bosonlength(string)
    @assert length(n) == N "Length of n must be equal to the number of modes"
    @assert length(m) == N "Length of m must be equal to the number of modes"
    for k in 1:N
        i = Int(string.v[2k-1])
        j = Int(string.v[2k])
        res *= inner(n[k], i, j, m[k])
    end
    return res
end

"""
    inner(n::Int, o::Operator, m::Int)

Return <n|o|m> where |n> and |m> are foch states.
TODO : many body
"""
function inner(n::Int, o::Operator, m::Int)
    @assert bosonlength(o) == 1 "Operator must be a single mode operator"
    res = 0
    for k in 1:length(o)
        res += o.coeffs[k]*inner(n, o.strings[k], m)
    end
    return res
end







"""
    expect(o::Operator, in_state::n, out_state::m)

Return <n|o|m> where |m> and |n> are foch states.
TODO : many body
"""
function expect(o::Operator, in_state::Int, out_state::Int)
    return inner(out_state, o, in_state)
end
