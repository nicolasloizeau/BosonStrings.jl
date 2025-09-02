

emptydict(o::AbstractOperator) = Dictionary{eltype(o.strings),eltype(o.coeffs)}()


function compress(o::Operator)
    d = emptydict(o)
    for i in 1:length(o)
        setwith!(+, d, o.strings[i], o.coeffs[i])
    end
    o1 = typeof(o)()
    for v in keys(d)
        if abs(d[v]) > 1e-16
            push!(o1.strings, v)
            push!(o1.coeffs, d[v])
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
function Base.:+(o1::O, o2::O) where {O<:AbstractOperator}
    @assert typeof(o1) == typeof(o2) "Adding operators of different types"

    d = emptydict(o1)

    # add the first operator
    ps, cs = o1.strings, o1.coeffs
    @inbounds for i in eachindex(ps)
        setwith!(+, d, ps[i], cs[i])
    end
    # subtract the second operator
    ps, cs = o2.strings, o2.coeffs
    @inbounds for i in eachindex(ps)
        setwith!(+, d, ps[i], cs[i])
    end

    # assemble output
    o3 = typeof(o1)(collect(keys(d)), collect(values(d)))
    return cutoff(o3, 1e-16)
end
Base.:+(o::AbstractOperator, a::Number) = o + a * one(o)
Base.:+(a::Number, o::AbstractOperator) = a * one(o) + o



function Base.:-(o1::O, o2::O) where {O<:AbstractOperator}

    d = emptydict(o1)

    # add the first operator
    ps, cs = o1.strings, o1.coeffs
    @inbounds for i in eachindex(ps)
        setwith!(+, d, ps[i], cs[i])
    end
    # subtract the second operator
    ps, cs = o2.strings, o2.coeffs
    @inbounds for i in eachindex(ps)
        setwith!(+, d, ps[i], -cs[i])
    end
    o3 = typeof(o1)(collect(keys(d)), collect(values(d)))
    return cutoff(o3, 1e-16)
end





function Base.:*(o::AbstractOperator, a::Number)
    o1 = deepcopy(o)
    o1.coeffs .*= a
    return o1
end
Base.:*(a::Number, o::AbstractOperator) = o * a




"""
    Base.:/(o::Operator, a::Number)

Divide an operator by a number
"""
function Base.:/(o::AbstractOperator, a::Number)
    o1 = deepcopy(o)
    o1.coeffs ./= a
    return o1
end

"""
    Base.:-(o::Operator)
    Base.:-(o1::Operator, o2::Operator)
    Base.:-(o::Operator, a::Number)
    Base.:-(a::Number, o::Operator)

Subtraction between operators and numbers
"""
Base.:-(o::AbstractOperator) = -1 * o
Base.:-(o::AbstractOperator, a::Number) = o + (-a * one(o))
Base.:-(a::Number, o::AbstractOperator) = (a * one(o)) - o


function Base.:*(s1::BosonString{1}, s2::BosonString{1})
    o = Operator(1)
    k = s1.v[1]
    l = s1.v[2]
    m = s2.v[1]
    n = s2.v[2]
    for j in 0:min(l, m)
        C = binomial(m, j)
        P = binomial(l, j) * factorial(j)
        v = zeros(Int, 2)
        v[1] = m - j + k
        v[2] = l - j + n
        push!(o.strings, BosonString{1}(v))
        push!(o.coeffs, C * P)
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

function Base.:*(s1::BosonString, s2::BosonString)
    @assert length(s1) == length(s2) "Multiplying strings of different lengths"
    N = length(s1) ÷ 2
    single_operators::Vector{Operator} = []
    for n in 1:N
        s3 = BosonString{1}((s1.v[n*2-1], s1.v[n*2]))
        s4 = BosonString{1}((s2.v[n*2-1], s2.v[n*2]))
        o = mul_strings(s1,s4)
        push!(single_operators, o)
    end
    return tensor_product(single_operators)
end





"""
    Base.:*(o1::Operator, o2::Operator)

Multiplication of two operators. Only supports single boson operator for now.
"""
function Base.:*(o1::Operator, o2::Operator)
    @assert typeof(o1)==typeof(o2) "Multiplying operators of different dimention"
    o = typeof(o1)()
    for i in 1:length(o1.strings)
        for j in 1:length(o2.strings)
            o += o1.strings[i] * o2.strings[j] * o1.coeffs[i] * o2.coeffs[j]
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
    return maximum(abs.(o3.coeffs)) < tol
end
