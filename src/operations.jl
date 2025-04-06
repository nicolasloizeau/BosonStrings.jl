


"""return the index of the 1 string"""
function ione(o::Operator)
    for i in 1:length(o)
        if norm(o.v[i]) == 0
            return i
        end
    end
    return -1
end


function compress(o::Operator)
    d = Dict{Vector{Int},Complex{Float64}}()
    for i in 1:length(o)
        if haskey(d, o.v[i])
            d[o.v[i]] += o.coef[i]
        else
            d[o.v[i]] = o.coef[i]
        end
    end
    o1 = Operator(o.N)
    for v in keys(d)
        if abs(d[v]) > 1e-16
            push!(o1.v, v)
            push!(o1.coef, d[v])
        end
    end
    return o1
end

"""
    Base.:+(o1::Operator, o2::Operator)
    Base.:+(o::Operator, a::Number)
    Base.:+(a::Number, o::Operator)

Addition between operators and numbers
"""
function Base.:+(o1::Operator, o2::Operator)
    @assert o1.N == o2.N "Adding operators of different dimension"
    o3 = Operator(o1.N)
    o3.v = vcat(o1.v, o2.v)
    o3.coef = vcat(o1.coef, o2.coef)
    return compress(o3)
end

function Base.:+(o::Operator, a::Number)
    o1 = deepcopy(o)
    i = ione(o)
    if i >= 0
        o1.coef[ione(o)] += a
    else
        push!(o1.coef, a)
        push!(o1.v, zeros(Int, o.N * 2))
    end
    return o1
end

Base.:+(a::Number, o::Operator) = o + a



function Base.:*(o::Operator, a::Number)
    o1 = deepcopy(o)
    o1.coef .*= a
    return o1
end

Base.:*(a::Number, o::Operator) = o * a


"""
    Base.:/(o::Operator, a::Number)

Divide an operator by a number
"""
function Base.:/(o::Operator, a::Number)
    o1 = deepcopy(o)
    o1.coef ./= a
    return o1
end

"""
    Base.:-(o::Operator)
    Base.:-(o1::Operator, o2::Operator)
    Base.:-(o::Operator, a::Number)
    Base.:-(a::Number, o::Operator)

Subtraction between operators and numbers
"""
Base.:-(o::Operator) = -1 * o
Base.:-(o1::Operator, o2::Operator) = o1 + (-o2)
Base.:-(o::Operator, a::Number) = o + (-a)
Base.:-(a::Number, o::Operator) = a + (-o)


# #TODO this is single boson only
# function mul_strings(s1::Vector{Int}, s2::Vector{Int})
#     N = length(s1) ÷ 2
#     o = Operator(length(s1) ÷ 2)
#     k = s1[1]
#     l = s1[2]
#     m = s2[1]
#     n = s2[2]
#     for j in 0:min(l, m)
#         C = binomial(m, j)
#         P = binomial(l, j) * factorial(j)
#         v = zeros(Int, N * 2)
#         v[1] = m - j + k
#         v[2] = l - j + n
#         push!(o.v, v)
#         push!(o.coef, C * P)
#     end
#     return compress(o)
# end

#TODO only works if operators have only one active mode at the same place
function mul_strings(s1::Vector{Int}, s2::Vector{Int})
    @assert length(s1) == length(s2) "Operator vectors must match length"
    @assert length(s1) % 2 == 0 "Length must be 2*N for some N" #Not really necessary but wanted to be sure

    N = length(s1) ÷ 2
    
    mode1 = -1
    for i in 1:N
        if s1[2i-1] != 0 || s1[2i] != 0
            mode1 = i
            break
        end
    end
    
    mode2 = -1
    for i in 1:N
        if s2[2i-1] != 0 || s2[2i] != 0
            mode2 = i
            break
        end
    end

    #assume they occupy the *same* mode. 
    @assert mode1 == mode2 "The two strings do not occupy the same mode."
    i = mode1

    #extract single-mode exponents
    k = s1[2i - 1]
    l = s1[2i]
    m = s2[2i - 1]
    n = s2[2i]

    #create an Operator for the result, same total number of modes (N)
    o = Operator(N)

    #single-mode expansion in the chosen mode i
    for j in 0:min(l, m) #TODO MERT ASK: why l and m here but not k and m?
        c1 = binomial(m, j)
        c2 = binomial(l, j)*factorial(j) 
        mult_coef = c1 * c2

        #build an exponent vector for all N modes, all zero except mode i
        new_exps = zeros(Int, 2N)
        new_exps[2i - 1] = k + m - j   #creation exponent for mode i
        new_exps[2i]     = l + n - j   #annihilation exponent for mode i

        push!(o.v, new_exps)
        push!(o.coef, mult_coef)
    end

    return o
end

"""
    Base.:*(o1::Operator, o2::Operator)

Multiplication of two operators. Only supports single boson operator for now.
"""
function Base.:*(o1::Operator, o2::Operator)
    @assert o1.N == o2.N "Multiplying operators of different dimention" #TODO: remove this assertion, Operator(1) with single mode can be multiplied with Operator(2) on two modes - result is Operator(2).
    #@assert o1.N == 1 "Only support single boson multiplication"
    o = Operator(o1.N)
    for i in 1:length(o1.v)
        for j in 1:length(o2.v)
            o += mul_strings(o1.v[i], o2.v[j]) * o1.coef[i] * o2.coef[j]
        end
    end
    return o
end

"""
    equal(o1, o2; tol=1e-10)

Compare two operators. Return true if they are equal within the tolerance tol.
"""
function equal(o1::Operator, o2::Operator; tol=1e-10)
    o3 = o1 - o2
    if length(o3) == 0
        return true
    end
    return maximum(abs.(o3.v)) < tol
end
