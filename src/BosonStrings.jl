module BosonStrings


export Operator
export equal, inner, op_to_dense

using LinearAlgebra

include("singleboson.jl")
include("operators.jl")
include("io.jl")
include("operations.jl")
include("dense.jl")

end
