



abstract type AbstractOperator end


struct BosonString{N}
    v::MVector{N2, UInt} where {N2}
end

Base.hash(s::BosonString, h::UInt) = hash(s.v, h)
Base.:(==)(s1::BosonString, s2::BosonString) = s1.v == s2.v

"""
Represent an normal ordered boson operator
Each key is a
"""
struct Operator{B<:BosonString,T<:Number} <: AbstractOperator
    strings::Vector{B}
    coeffs::Vector{T}
end

bosonstringtype(::Type{<:Operator{B}}) where {B} = B
bosonstringtype(x::AbstractOperator) = paulistringtype(typeof(x))
bosonstringtype(N::Integer) = BosonString{N}
scalartype(::Type{Operator{P,T}}) where {P,T} = T



bosonlength(x::AbstractOperator) = bosonlength(typeof(x))
bosonlength(x::Type{<:AbstractOperator}) = bosonlength(bosonstringtype(x))
bosonlength(::Type{<:BosonString{N}}) where {N} = N
bosonlength(x::BosonString{N}) where {N} = N



Operator(N::Int) = Operator{bosonstringtype(N),ComplexF64}()
Operator{B,T}() where {B,T} = Operator{B,T}(B[], T[])


function BosonString{N}(v::Vector{Int}) where {N}
    @assert length(v) == N*2 "BosonString must have length $N*2"
    return BosonString{N}(MVector{N*2, Int}(v))
end

Base.length(o::Operator) = length(o.strings)


Base.one(x::AbstractOperator) = one(typeof(x))
Base.zero(x::AbstractOperator) = zero(typeof(x))
function Base.one(::Type{BosonString{N}}) where {N}
    v = MVector{N*2, Int}(zeros(Int, N*2))
    BosonString{N}(v)
end


Base.copy(p::BosonString{N}) where {N} = BosonString{N}(copy(p.v), copy(p.w))

Base.one(::Type{O}) where {O<:Operator} = O([one(bosonstringtype(O))], [one(scalartype(O))])
Base.zero(::Type{O}) where {O<:Operator} = O()
Base.copy(o::Operator) = typeof(o)(copy(o.strings), copy(o.coeffs))
