
"""
    inner(n::Int, o::Operator, m::Int)

Return <n|o|m> where |n> and |m> are foch states.
TODO : many body
"""
function inner(n::Int, o::Operator, m::Int)
    @assert o.N == 1 "Operator must be a single mode operator"
    res = 0
    for k in 1:length(o.v)
        i = o.v[k][1]
        j = o.v[k][2]
        if (n - i >= 0 && m - j >= 0) && (n - i == m - j)
            c = sqrt(factorial(n) / factorial(n - i) * factorial(m) / factorial(m - j))
            res += c * o.coef[k]
        end
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
