module BosonStrings


export Operator, BosonString
export equal, op_to_dense, com
export expect, inner
export cutoff
export rk4, rk4_lindblad

using Random
using LinearAlgebra
using StaticArrays
using Dictionaries


# include("singleboson.jl")
include("operators.jl")
include("io.jl")
include("operations.jl")
include("dense.jl")
# include("evolution.jl")
include("truncation.jl")
include("states.jl")


end
