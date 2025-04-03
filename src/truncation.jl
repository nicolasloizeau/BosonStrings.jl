
"""
    trim(o::Operator, max_strings::Int)

Keep the first `max_strings` terms with largest coeficients.
"""
function trim(o::Operator, max_strings::Int)
    if length(o) <= max_strings
        return deepcopy(o)
    end
    i = sortperm(abs.(o.coef), rev=true)[1:max_strings]
    o1 = typeof(o)(o.N, o.v[i], o.coef[i])
    return o1
end
