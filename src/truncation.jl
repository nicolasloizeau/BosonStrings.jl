
# <!--"""
#     trim(o::Operator, max_strings::Int)

# Keep the first `max_strings` terms with largest coeficients.
# """-->
# function trim(o::Operator, max_strings::Int)
#     if length(o) <= max_strings
#         return deepcopy(o)
#     end
#     i = sortperm(abs.(o.coef), rev=true)[1:max_strings]
#     o1 = typeof(o)(o.N, o.v[i], o.coef[i])
#     return o1
# end


function cutoff(o::AbstractOperator, epsilon::Real; keepnorm::Bool=false)
    o2 = zero(o)
    for i in 1:length(o)
        if abs(o.coeffs[i]) > epsilon
            push!(o2.coeffs, o.coeffs[i])
            push!(o2.strings, o.strings[i])
        end
    end
    if keepnorm
        return o2 * opnorm(o) / opnorm(o2)
    end
    return o2
end
