



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
