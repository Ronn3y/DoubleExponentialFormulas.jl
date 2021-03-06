using LinearAlgebra: norm


struct QuadDEO end


"""
    quaddeo(f::Function, ω::Real, θ::Real, a::Real, b::Real;
            h0::Real=one(ω)/5, maxlevel::Integer=12,
            atol::Real=zero(ω),
            rtol::Real=atol>0 ? zero(atol) : sqrt(eps(typeof(atol))))

Numerically integrate `f(x)` over an arbitrary interval [a, b] and return the
integral value `I` and an estimated error `E`. The `quaddeo` function is
specialized for the decaying oscillatory integrands,

    f(x) = f₁(x)sin(ωx + θ),

where `f₁(x)` is a decaying algebraic function. `ω` and `θ` are the frequency
and the phase of the oscillatory part of the integrand. If the oscillatory part
is `sin(ωx)`, then `θ = 0.0`; if it is `cos(ωx)` instead, then `θ = π/(2ω)`.
The `E` is not exactly equal to the difference from the true value. However,
one can expect that the integral value `I` is converged if
`E <= max(atol, rtol*norm(I))` is true. Otherwise, the obtained `I` would be
unreliable; the number of repetitions exceeds the `maxlevel` before converged.
Optionally, one can divide the integral interval [a, b, c...], which returns
`∫ f(x)dx in [a, b] + ∫f(x)dx in [b, c[1]] + ⋯`.  It is worth noting that each
endpoint allows discontinuity or singularity.

The integrand `f` can also return any value other than a scalar, as far as
`+`, `-`, multiplication by real values, and `LinearAlgebra.norm`, are
implemented. For example, `Vector` or `Array` of numbers are acceptable
although, unfortunately, it may not be very performant.

# Examples
```jldoctest
julia> using DoubleExponentialFormulas

julia> using LinearAlgebra: norm

julia> f(x) = sin(x)/x;

julia> I, E = quaddeo(f, 1.0, 0.0, 0.0, Inf);

julia> I ≈ π/2
true

julia> E ≤ sqrt(eps(Float64))*norm(I)
true
```
"""
quaddeo(f::Function, ω::Real, θ::Real, a::Real, b::Real;
        h0::Real=one(ω)/5, maxlevel::Integer=12,
        atol::Real=zero(ω), rtol::Real=atol>0 ? zero(atol) : sqrt(eps(typeof(atol)))) =
    quaddeo_entrance(f, ω, θ, a, b, h0, maxlevel, atol, rtol)

function quaddeo(f::Function, ω::Real, θ::Real, a::Real, b::Real, c::Real...;
                 h0::Real=one(ω)/5, maxlevel::Integer=12,
                 atol::Real=zero(ω), rtol::Real=atol>0 ? zero(atol) : sqrt(eps(typeof(atol))))
    bc = (b, c...)
    n = length(bc)
    _atol = atol/n
    I, E = quaddeo_entrance(f, ω, θ, a, b, h0, maxlevel, atol, rtol)
    for i in 2:n
        dI, dE = quaddeo_entrance(f, ω, θ, bc[i-1], bc[i], h0, maxlevel, atol, rtol)
        I += dI
        E += dE
    end
    return I, E
end


function quaddeo_entrance(f, ω, θ, a, b, h0, maxlevel, atol, rtol)
    @assert maxlevel > 0
    @assert h0 > 0
    _ω, _θ, _a, _b, _h0 = float.(promote(ω, θ, a, b, h0))
    if a > b
        I, E = quaddeo_main(f, _ω, _θ, _b, _a, _h0, maxlevel, atol, rtol)
        return -I, E
    else
        return quaddeo_main(f, _ω, _θ, _a, _b, _h0, maxlevel, atol, rtol)
    end
end
function quaddeo_main(f, ω::T, θ::T, a::T, b::T, h0::T, maxlevel, atol, rtol) where {T<:AbstractFloat}
    if a == b
        M = π/h0
        δ = θ/M
        t0 = zero(T) + δ
        x0, w0 = samplepoint(QuadDEO, t0)
        Σ = f(M*x0)*w0
        I = M*h0*Σ
        return zero(typeof(I)), zero(eltype(I))
    end

    if a == -Inf && b == Inf
        _atol = atol/2
        I⁻, E⁻ = quaddeo_main(f, ω, θ, a, zero(a), h0, maxlevel, _atol, rtol)
        I⁺, E⁺ = quaddeo_main(f, ω, θ, zero(b), b, h0, maxlevel, _atol, rtol)
        return I⁺ + I⁻, E⁺ + E⁻
    elseif b == Inf
        if a == 0
            return quaddeo_main(f, ω, θ, h0, maxlevel, atol, rtol)
        else
            return quaddeo_main(u -> f(u + a), ω, θ, h0, maxlevel, atol, rtol)
        end
    elseif a == -Inf
        if b == 0
            return quaddeo_main(u -> f(-u), ω, θ, h0, maxlevel, atol, rtol)
        else
            return quaddeo_main(u -> f(-u + b), ω, θ, h0, maxlevel, atol, rtol)
        end
    else
        _atol = atol/2
        if a < 0 && b ≤ 0
            Ia, Ea = quaddeo_main(f, ω, θ, T(-Inf), a, h0, maxlevel, _atol, rtol)
            Ib, Eb = quaddeo_main(f, ω, θ, T(-Inf), b, h0, maxlevel, _atol, rtol)
            return Ib - Ia, Ea + Eb
        elseif a ≥ 0 && b > 0
            Ia, Ea = quaddeo_main(f, ω, θ, a, T(Inf), h0, maxlevel, _atol, rtol)
            Ib, Eb = quaddeo_main(f, ω, θ, b, T(Inf), h0, maxlevel, _atol, rtol)
            return Ia - Ib, Ea + Eb
        else
            I⁻, E⁻ = quaddeo_main(f, ω, θ, a, zero(a), h0, maxlevel, _atol, rtol)
            I⁺, E⁺ = quaddeo_main(f, ω, θ, zero(b), b, h0, maxlevel, _atol, rtol)
            return I⁺ + I⁻, E⁺ + E⁻
        end
    end
end
function quaddeo_main(f, ω::T, θ::T, h0::T, maxlevel, atol, rtol) where {T<:AbstractFloat}
    I = integrate(QuadDEO, f, ω, θ, h0, atol, rtol)
    E = zero(eltype(I))
    for level in 1:maxlevel
        h = h0/2^level
        prevI = I
        I = integrate(QuadDEO, f, ω, θ, h, atol, rtol)
        E = estimate_error(T, prevI, I)
        tol = max(norm(I)*rtol, atol)
        !(E > tol) && break
    end
    return I, E
end


function integrate(::Type{QuadDEO}, f, ω, θ, h, atol, rtol)
    M = π/(h*ω)
    δ = θ/M
    t0 = zero(δ) + δ
    x0, w0 = samplepoint(QuadDEO, t0)
    Σ = f(M*x0)*w0
    I = M*Σ*h
    chunklen = 10

    k = 1
    while true
        Σ, loop_done = integrate_chunk⁺(QuadDEO, f, M, δ, k, h, Σ, chunklen)
        k += chunklen
        prevI = I
        I = M*h*Σ
        loop_done && break
        dI = norm(prevI - I)
        tol = max(norm(I)*rtol, atol)
        dI ≤ tol && break
    end

    k = -1
    while true
        Σ, loop_done = integrate_chunk⁻(QuadDEO, f, M, δ, k, h, Σ, chunklen)
        k -= chunklen
        prevI = I
        I = M*h*Σ
        loop_done && break
        dI = norm(prevI - I)
        tol = max(norm(I)*rtol, atol)
        dI ≤ tol && break
    end
    return I
end


function integrate_chunk⁺(::Type{QuadDEO}, f, M, δ, k, h, Σ, chunklen)
    loop_done = false
    for _ in 1:chunklen
        t = k*h + δ
        if isinf(sinh(t))
            loop_done = true
            break
        end

        x, w = samplepoint(QuadDEO, t)
        dΣ = f(M*x)*w
        if all(isnan.(dΣ))
            loop_done = true
            break
        end

        Σ += dΣ
        k += 1
    end
    return Σ, loop_done
end


function integrate_chunk⁻(::Type{QuadDEO}, f, M, δ, k, h, Σ, chunklen)
    loop_done = false
    for _ in 1:chunklen
        t = k*h + δ
        if isinf(sinh(t))
            loop_done = true
            break
        end

        x, w = samplepoint(QuadDEO, t)
        if x == 0
            # avoid end-point singularity
            loop_done = true
            break
        end

        dΣ = f(M*x)*w
        if all(isnan.(dΣ))
            loop_done = true
            break
        end

        Σ += dΣ
        k -= 1
    end
    return Σ, loop_done
end


function samplepoint(::Type{QuadDEO}, t::T) where {T<:AbstractFloat}
    # The following equation is used for the variable conversion.
    #   ϕ(t) = (t + sqrt(t² + exp(π - K*cosh(t))))/2
    # Ref. (Japanese) : http://www.kurims.kyoto-u.ac.jp/~ooura/intdefaq-j.html
    #
    # NOTE: might be worth checking this?
    #       https://doi.org/10.1016/S0377-0427(99)00223-X
    K = T(2π)
    A = exp(π - K*cosh(t))
    B = sqrt(t^2 + A)
    ϕ  = (t + B)/2
    ϕ′ = T(0.5) + (2t - K*A*sinh(t))/(4*B)
    return ϕ, ϕ′
end
