


"""
    Base.:+(o::Operator, term::Tuple{Number, Vararg{Tuple{Int,Int,Int}} })

Add a term to an operator. The term is of the form `c, (site1, n1, m1), (site2, n2, m2) ...`
where triplets `(site, n, m)` represent ``a_{site}^{\\dagger n} a_{site}^m``.
The following example adds the term ``a_{1}^{\\dagger 1} a_{1}^1    a_{2}^{\\dagger 2} a_{2}^3    a_{4}^{\\dagger 5} a_{4}^5`` to a 4-bosons operator:

```julia
o = Operator(4)
o += 1, (1, 1, 1), (2, 2, 3), (4, 5, 5)
```
```
julia> o
(1.0 + 0.0im) (†1)(1)·(†2)(3)·(†0)(0)·(†5)(5)
```

"""
function Base.:+(o::Operator, term::Tuple{Number, Vararg{Tuple{Int,Int,Int}} })
    c = term[1]
    term = term[2:end]
    newterm = zeros(Int, o.N*2)
    for sub in term
        n = sub[1]
        newterm[n*2-1] = sub[2]
        newterm[n*2] = sub[3]
    end
    push!(o.v, newterm)
    push!(o.coef, c)
    return compress(o)
end


function disp_string(string::Vector{Int})
    s = ""
    for i in 1:length(string)
        c = string[i]
        if i%2 == 1
            s *= "(†$c)"
        else
            s *= "($c)·"
        end
    end
    return s[1:end-1]
end

"""
    Base.show(io::IO, o::Operator)

Print an operator in a human-readable format. The operator is printed as a sum of terms, each term
is a coefficient followed by a string of boson operators.
"""
function Base.show(io::IO, o::Operator)
    if length(o) == 0
        println(io, "0")
        return
    end
    for i in 1:length(o)
        string = o.v[i]
        c = o.coef[i]
        s = disp_string(string)
        println(io, "($(round(c, digits=10))) $s")
    end
end
