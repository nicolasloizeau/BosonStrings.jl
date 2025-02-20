# BosonStrings

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://nicolasloizeau.github.io/BosonStrings.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://nicolasloizeau.github.io/BosonStrings.jl/dev/)
[![Build Status](https://github.com/nicolasloizeau/BosonStrings.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nicolasloizeau/BosonStrings.jl/actions/workflows/CI.yml?query=branch%3Amain)




Normal ordered strings of bosonic operators in Julia.

## Installation

```julia
] add https://github.com/nicolasloizeau/BosonStrings.jl
```

## Getting started

Compute $a_{1}^{\\dagger 1} a_{1}^1 \\cdot a_{1}^{\\dagger 2} a_{1}^2$
```julia
using BosonStrings
o1 = Operator(1)
o1 += 1, (1, 1, 1)
o2 = Operator(1)
o2 += 1, (1, 2, 2)
o = o1 * o2
println(o)
```
```
julia> o
(1.0 + 0.0im) (†3)(3)
(2.0 + 0.0im) (†2)(2)
```
we get $a_{1}^{\\dagger 1} a_{1}^1 \\cdot a_{1}^{\\dagger 2} a_{1}^2 = a_{1}^{\\dagger 3} a_{1}^3 + 2a_{1}^{\\dagger 2} a_{1}^2$
