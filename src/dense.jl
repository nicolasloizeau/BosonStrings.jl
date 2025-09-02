


# dense boson opeartors for testing

"""
    annihilation(d::Int)

Create a d x d annihilation operator, dense matrix.
"""
function annihilation(d::Int)
    o = zeros(Complex{Float64}, d, d)
    for i in 1:d-1
        o[i, i+1] = sqrt(i)
    end
    return o
end

"""
    Base.:+(o::Matrix, term::Tuple{Number, Tuple{Int,Int} })

Add a term to a dense matrix operator.
To add a term of the form `c*(†n)(m)`, do `o+=c,n,m`
"""
function Base.:+(o::Matrix, term::Tuple{Number, Tuple{Integer,Integer} })
    @assert size(o)[1] == size(o)[2]
    c = term[1]
    n = term[2][1]
    m = term[2][2]
    a = annihilation(size(o)[1])
    adag = transpose(a)
    return deepcopy(o) +c* adag^n*a^m
end

"""
    inner(n::Int, o::Matrix, m::Int)

Return <n|o|m> where `o` is a single boson operator represented as a dense matrix.
"""
function inner(n::Int, o::Matrix, m::Int)
    @assert size(o)[1] == size(o)[2]
    @assert n >= 0 && m >= 0
    @assert n < size(o)[1] && m < size(o)[1]
    d = size(o)[1]
    sn = zeros(Float64, d)
    sm = zeros(Float64, d)
    sn[n+1] = 1
    sm[m+1] = 1
    return sn' * o * sm
end



"""
    op_to_dense(o::Operator, dim::Int)

Convert a boson `Operator` to a dense matrix of dimention `dim`.
"""
function op_to_dense(o::Operator, dim::Int)
    @assert bosonlength(o) == 1
    odense = zeros(Complex{Float64}, dim, dim)
    for k in 1:length(o)
        i = o.strings[k].v[1]
        j = o.strings[k].v[2]
        c = o.coeffs[k]
        odense += c, (i, j)
    end
    return odense
end
