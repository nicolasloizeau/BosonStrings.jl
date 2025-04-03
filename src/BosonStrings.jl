module BosonStrings


export Operator
export equal, inner, op_to_dense, com
export trim
export rk4

using Random
using LinearAlgebra

include("singleboson.jl")
include("operators.jl")
include("io.jl")
include("operations.jl")
include("dense.jl")
include("evolution.jl")
include("truncation.jl")
include("states.jl")


end
