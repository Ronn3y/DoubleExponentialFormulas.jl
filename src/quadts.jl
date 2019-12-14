using LinearAlgebra: norm


struct QuadTSWeightTable{T<:AbstractFloat} <: AbstractVector{Tuple{T,T}}
    table::Vector{Tuple{T,T}}
end
Base.size(wt::QuadTSWeightTable) = size(wt.table)
Base.getindex(wt::QuadTSWeightTable, i::Int) = getindex(wt.table, i)


struct QuadTS{T<:AbstractFloat,N}
    h0::T
    origin::Tuple{T,T}
    tables::NTuple{N,QuadTSWeightTable{T}}
end
function QuadTS(T::Type{<:AbstractFloat}; maxlevel::Integer=10, h0::Real=one(T)/h0inv)
    @assert maxlevel > 0
    t0 = zero(T)
    tables, origin = generate_tables(QuadTSWeightTable, maxlevel, T(h0))
    QuadTS{T,maxlevel}(T(h0), origin, tables)
end

function (q::QuadTS{T,N})(f::Function; atol::Real=zero(T),
                          rtol::Real=atol>0 ? zero(T) : sqrt(eps(T))) where {T<:AbstractFloat,N}
    x0, w0 = q.origin
    I = f(x0)*w0
    h0 = q.h0
    Ih = I*h0
    E = zero(eltype(Ih))
    sample(t) = f(t[1])*t[2] + f(-t[1])*t[2]
    for level in 1:N
        I += sum_pairwise(sample, q.tables[level])
        h = h0/2^(level - 1)
        prevIh = Ih
        Ih = I*h
        E = norm(prevIh - Ih)
        !(E > max(norm(Ih)*rtol, atol)) && level > 1 && break
    end
    Ih, E
end


function generate_tables(::Type{QuadTSWeightTable}, maxlevel::Integer, h0::T) where {T<:AbstractFloat}
    ϕ(t) = tanh(sinh(t)*π/2)
    ϕ′(t) = (cosh(t)*π/2)/cosh(sinh(t)*π/2)^2
    tables = Vector{QuadTSWeightTable}(undef, maxlevel)
    for level in 1:maxlevel
        table = Tuple{T,T}[]
        h = h0/2^(level - 1)
        k = 1
        step = level == 1 ? 1 : 2
        while true
            t = k*h
            xk = ϕ(t)
            1 - xk ≤ eps(T) && break
            wk = ϕ′(t)
            wk ≤ floatmin(T) && break
            push!(table, (xk, wk))
            k += step
        end
        reverse!(table)
        tables[level] = QuadTSWeightTable{T}(table)
    end

    x0 = ϕ(zero(T))
    w0 = ϕ′(zero(T))
    origin = (x0, w0)
    Tuple(tables), origin
end
