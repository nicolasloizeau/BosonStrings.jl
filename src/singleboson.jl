



mutable struct SingleBoson
    dict::Dict{Vector{Int},Complex{Float64}}
end

SingleBoson() = SingleBoson(Dict{Vector{Int},Complex{Float64}}())


function Base.show(io::IO, o::SingleBoson)
    if length(o.dict) == 0
        println(io, "0")
        return
    end
    for string in keys(o.dict)
        c = o.dict[string]
        s = disp_single_string(string)
        if s == "(0)"
            s = ""
        end
        println(io, "($(round(c, digits=10))) ", s)
    end
end


function compress(arr::Vector{Int})
    result = Int[]
    current_sum = arr[1]
    for i in 2:length(arr)
        if (current_sum ≥ 0 && arr[i] ≥ 0) || (current_sum < 0 && arr[i] < 0)
            current_sum += arr[i]
        else
            if current_sum ≠ 0
                push!(result, current_sum)
            end
            current_sum = arr[i]
        end
    end
    push!(result, current_sum)
    return result
end

function compress(o::SingleBoson)
    d = Dict{Vector{Int},Complex{Float64}}()
    for string in keys(o.dict)
        compressed = compress(string)
        if haskey(d, compressed)
            d[compressed] += o.dict[string]
        else
            d[compressed] = o.dict[string]
        end
    end
    for string in keys(d)
        if abs(d[string]) < 1e-16
            delete!(d, string)
        end
    end
    return SingleBoson(d)
end


function Base.:+(o1::SingleBoson, o2::SingleBoson)
    d = Dict{Vector{Int},Complex{Float64}}()
    for string in keys(o1.dict)
        d[string] = o1.dict[string]
    end
    for string in keys(o2.dict)
        if haskey(d, string)
            d[string] += o2.dict[string]
        else
            d[string] = o2.dict[string]
        end
    end
    return compress(SingleBoson(d))
end



function Base.:+(o::SingleBoson, term::Tuple{Number,Vector{Int}})
    if term[1] in keys(o.dict)
        o.dict[term[2]] += term[1]
    else
        o.dict[term[2]] = term[1]
    end
    return o
end

function Base.:*(a::Number, o::SingleBoson)
    o1 = deepcopy(o)
    for string in keys(o1.dict)
        o1.dict[string] *= a
    end
    return o1
end

Base.:*(o::SingleBoson, a::Number) = o * a
Base.:-(o::SingleBoson) = -1 * o
Base.:-(o1::SingleBoson, o2::SingleBoson) = compress(o1 + (-o2))

function disp_single_string(s::Vector{Int})
    s2 = ""
    for c in s
        if c > 0
            # s2 *= "a⁺" * to_superscript(c)
            s2 *= "(†$c)"
        else
            # s2 *= "a" * to_superscript(-c)
            s2 *= "($(-c))"
        end
    end
    return s2
end


function is_ordered(string::Vector{Int})
    s = compress(string)
    if length(s) == 1 || length(s) == 2 && s[1] > 0
        return true
    end
    return false
end

function is_ordered(o::SingleBoson)
    for string in keys(o.dict)
        if !is_ordered(string)
            return false
        end
    end
    return true
end

function order_step(string::Vector{Int})
    if is_ordered(string)
        o = SingleBoson()
        o += 1, string
        return o
    end
    pos = 1
    # look for the position of the first disordered term
    for i in 1:length(string)-1
        if string[i] < 0 && string[i+1] > 0
            pos = i
            break
        end
    end
    l = abs(string[pos])
    m = string[pos+1]
    o = SingleBoson()
    for j in 0:min(l, m)
        string2 = copy(string)
        C = binomial(m, j)
        P = binomial(l, j) * factorial(j)
        string2[pos] = m - j
        string2[pos+1] = -(l - j)
        o += C * P, string2
    end
    return compress(o)
end


function order_step(o::SingleBoson)
    o2 = SingleBoson()
    for string in keys(o.dict)
        o2 += o.dict[string] * order_step(string)
    end
    return compress(o2)
end

function ordered(o::SingleBoson)
    while !is_ordered(o)
        o = order_step(o)
    end
    return o
end


function Base.:(==)(o1::SingleBoson, o2::SingleBoson)
    o1 = ordered(o1)
    o2 = ordered(o2)
    o3 = compress(o1 - o2)
    return length(o3.dict) == 0
end
