


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
    @assert o1.N == o2.N "Adding operators of different dimention"
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



function mul_strings(s1::NTuple{2,Int}, s2::NTuple{2,Int})
    N = length(s1) ÷ 2
    o = Operator(length(s1) ÷ 2)
    k = s1[1]
    l = s1[2]
    m = s2[1]
    n = s2[2]
    for j in 0:min(l, m)
        C = binomial(m, j)
        P = binomial(l, j) * factorial(j)
        v = zeros(Int, N * 2)
        v[1] = m - j + k
        v[2] = l - j + n
        push!(o.v, v)
        push!(o.coef, C * P)
    end
    return compress(o)
end


function tensor_product(operators::Vector{Operator})
    N = length(operators)
    o = Operator(N)
    ranges = [1:length(o) for o in operators]
    for indexes in Iterators.product(ranges...)
        v = zeros(Int, N * 2)
        for i in 1:N
            v[2*i-1] = operators[i].v[indexes[i]][1]
            v[2*i] = operators[i].v[indexes[i]][2]
        end
        push!(o.v, v)
        push!(o.coef, prod(operators[i].coef[indexes[i]] for i in 1:N))
    end
    return compress(o)
end

function mul_strings(s1::Vector{Int}, s2::Vector{Int})
    @assert length(s1) == length(s2) "Multiplying strings of different lengths"
    N = length(s1) ÷ 2
    if N == 1
        return mul_strings((s1[1], s1[2]), (s2[1], s2[2]))
    end
    single_operators::Vector{Operator} = [mul_strings((s1[n*2-1], s1[n*2]), (s2[n*2-1], s2[n*2])) for n in 1:N]
    return tensor_product(single_operators)
end





"""
    Base.:*(o1::Operator, o2::Operator)

Multiplication of two operators. Only supports single boson operator for now.
"""
function Base.:*(o1::Operator, o2::Operator)
    @assert o1.N == o2.N "Multiplying operators of different dimention"
    o = Operator(o1.N)
    for i in 1:length(o1.v)
        for j in 1:length(o2.v)
            o += mul_strings(o1.v[i], o2.v[j]) * o1.coef[i] * o2.coef[j]
        end
    end
    return o
end


function com(o1::Operator, o2::Operator)
    return o1 * o2 - o2 * o1
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
