

"""
Represent an normal ordered boson operator `o(N)` where `N` is the number of modes.
"""
mutable struct Operator
    N::Int
    v::Vector{Vector{Int}}
    coef::Vector{Complex{Float64}}
end

Operator(N::Int) = Operator(N, Int[], Complex{Float64}[])

function Base.length(o::Operator)
    return length(o.v)
end
