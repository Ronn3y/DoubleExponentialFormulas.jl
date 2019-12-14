using DoubleExponentialFormulas
using LinearAlgebra: norm
using Test

quadde32 = QuadDE(Float32)
quadde64 = QuadDE(Float64)
quaddeBF = QuadDE(BigFloat)

# Test integral interval [-1, 1] with QuadDE
let
    f(x::AbstractFloat) = 2/(1 + x^2)
    expect = π

    I, E = quadde32(f, -1, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -1, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, -1, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -1, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [a, b] with QuadDE
# a, b are arbitrary finite float numbers
let
    f(x::AbstractFloat) = 1/(1 + (x/2)^2)
    expect = π

    I, E = quadde32(f, -2, 2)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -2, 2)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -2, 2, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, -2, 0, 2)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -2, 0, 2)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -2, 0, 2, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [0, ∞] with QuadDE
let
    f(x::AbstractFloat) = exp(-x)
    expect = 1

    I, E = quadde32(f, 0, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, 0, 1, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [a, ∞] with QuadDE
let
    f(x::AbstractFloat) = exp(-(x - 1))
    expect = 1

    I, E = quadde32(f, 1, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 1, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 1, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, 1, 2, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 1, 2, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 1, 2, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [-∞, 0] with QuadDE
let
    f(x::AbstractFloat) = exp(x)
    expect = 1

    I, E = quadde32(f, -Inf, 0)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, 0)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, 0, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, -Inf, 1, 0)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, 1, 0)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, 1, 0, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [-∞, b] with QuadDE
let
    f(x::AbstractFloat) = exp(x + 1)
    expect = 1

    I, E = quadde32(f, -Inf, -1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, -1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, -1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, -Inf, -2, -1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, -2, -1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, -2, -1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test integral interval [-∞, ∞] with QuadDE
let
    f(x::AbstractFloat) = exp(-x^2)
    expect = sqrt(BigFloat(π))

    I, E = quadde32(f, -Inf, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)

    # Split into multiple integral intevals
    I, E = quadde32(f, -Inf, 0, Inf)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -Inf, 0, Inf)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, 0, Inf, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test ∫f(x)dx = 0 in [a, b] if a == b
let
    a = rand(Int)

    # Odd function
    I, E = quadde32(x -> x, a, a)
    @test I isa Float32
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(x -> x, a, a)
    @test I isa Float64
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quaddeBF(x -> x, a, a)
    @test I isa BigFloat
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)


    # Even function
    I, E = quadde32(x -> x^2, a, a)
    @test I isa Float32
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(x -> x^2, a, a)
    @test I isa Float64
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quaddeBF(x -> x^2, a, a)
    @test I isa BigFloat
    @test I ≈ 0
    @test E ≤ sqrt(eps(I))*norm(I)
end


# Test anti-symmetric equivalence when switching inteval limits with QuadDE
# ∫f(x)dx in [a, b] = -∫f(x)dx in [b, a]
let
    f(x::AbstractFloat) = exp(-x^2)

    # [-1, 1]
    I1, E1 = quadde32(f, -1, 1)
    I2, E2 = quadde32(f, 1, -1)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, -1, 1)
    I2, E2 = quadde64(f, 1, -1)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, -1, 1)
    I2, E2 = quaddeBF(f, 1, -1)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [a, b] (a and b are finite numbers)
    I1, E1 = quadde32(f, -2, 2)
    I2, E2 = quadde32(f, 2, -2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, -2, 2)
    I2, E2 = quadde64(f, 2, -2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, -2, 2)
    I2, E2 = quaddeBF(f, 2, -2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [0, ∞]
    I1, E1 = quadde32(f, 0, Inf)
    I2, E2 = quadde32(f, Inf, 0)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, 0, Inf)
    I2, E2 = quadde64(f, Inf, 0)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, 0, Inf)
    I2, E2 = quaddeBF(f, Inf, 0)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [a, ∞]
    I1, E1 = quadde32(f, 2, Inf)
    I2, E2 = quadde32(f, Inf, 2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, 2, Inf)
    I2, E2 = quadde64(f, Inf, 2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, 2, Inf)
    I2, E2 = quaddeBF(f, Inf, 2)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [-∞, 0]
    I1, E1 = quadde32(f, -Inf, 0)
    I2, E2 = quadde32(f, 0, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, -Inf, 0)
    I2, E2 = quadde64(f, 0, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, -Inf, 0)
    I2, E2 = quaddeBF(f, 0, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [-∞, b]
    I1, E1 = quadde32(f, -Inf, 2)
    I2, E2 = quadde32(f, 2, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, -Inf, 2)
    I2, E2 = quadde64(f, 2, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, -Inf, 2)
    I2, E2 = quaddeBF(f, 2, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)


    # [-∞, ∞]
    I1, E1 = quadde32(f, -Inf, Inf)
    I2, E2 = quadde32(f, Inf, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quadde64(f, -Inf, Inf)
    I2, E2 = quadde64(f, Inf, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)

    I1, E1 = quaddeBF(f, -Inf, Inf)
    I2, E2 = quaddeBF(f, Inf, -Inf)
    @test I1 ≈ -I2
    @test E1 ≤ sqrt(eps(I1))*norm(I1)
    @test E2 ≤ sqrt(eps(I2))*norm(I2)
end


# Test integrals are cited from:
# Kahaner, D.K.: Comparison of numerical quadrature formulas, Mathematical
# software, Rice, J.R. (Ed.), Academic Press. pp.229-259 (1971)

# NOTE that I couldn't get the original book, the below problems are cited
# from a second source.
# http://id.nii.ac.jp/1001/00011109/

# Test problem 1
let
    f(x::AbstractFloat) = exp(x)
    expect = BigFloat("1.71828182845904523536028747135")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 2
# non-smooth function
# NOTE: Unfortunately, this problem is very difficult for the default QuadDE.
#       The accuracy is (slowly) depending only on the step size of trapezoidal rule.
let
    f(x::AbstractFloat) = floor(min(x/3*10, one(x)))
    expect = BigFloat("7.00000000000000000000000000000e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test isapprox(I, expect, rtol=1e-3)
    @test_skip E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test isapprox(I, expect, rtol=1e-4)
    @test_skip E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=1e-4)
    @test_skip E ≤ rtol*norm(I)

    # In practical use, user may not know what actually f is.
    # However, if you know it then splitting the integral interval may help.
    I, E = quadde32(f, 0, 0.3, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 0.3, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-18
    I, E = quaddeBF(f, 0, 0.3, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 3
let
    f(x::AbstractFloat) = sqrt(x)
    expect = BigFloat("6.66666666666666666666666666666e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 4
let
    f(x::T) where {T<:AbstractFloat} = cosh(x)*92/100 - cos(x)
    expect = BigFloat("4.7942822668880166735857796183531e-1")

    I, E = quadde32(f, -1, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -1, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 5
let
    f(x::T) where {T<:AbstractFloat} = 1/(x^4 + x^2 + T(0.9))
    f(x::BigFloat) = 1/(x^4 + x^2 + BigFloat("0.9"))
    expect = BigFloat("1.5822329637296729331174689490262e0")

    I, E = quadde32(f, -1, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -1, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 6
let
    f(x::AbstractFloat) = x*sqrt(x)
    expect = BigFloat("4.00000000000000000000000000000e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 7
# Singular point at x = 0
let
    f(x::AbstractFloat) = 1/sqrt(x)
    expect = 2

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 8
let
    f(x::AbstractFloat) = 1/(x^4 + 1)
    expect = BigFloat("8.66972987339911037573995163882e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 9
let
    f(x::AbstractFloat) = 2/(2 + sin(x*314159/10000))
    expect = BigFloat("1.15470066904371304340692220986e0")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 10
let
    f(x::AbstractFloat) = 1/(1 + x)
    expect = BigFloat("6.93147180559945309417232121458e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 11
let
    f(x::AbstractFloat) = 1/(exp(x) + 1)
    expect = BigFloat("3.7988549304172247536823662649e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 12
# Singular point at x = 0
let
    f(x::AbstractFloat) = x/(exp(x) - 1)
    expect = BigFloat("7.77504634112248276417586545425e-1")

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 13
# Attenuating oscillation
let
    f(x::AbstractFloat) = sin(x*314159/1000)/(x*314159/100000)
    expect = BigFloat("9.0986452565692970698e-3")

    I, E = quadde32(f, 0.1, 1)
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0.1, 1)
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-18
    I, E = quaddeBF(f, 0.1, 1, rtol=rtol)
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 14
# Super fast decay around x ~ 0
# FIXME: split the integral range into parts
let
    f(x::T) where {T<:AbstractFloat} = 5*sqrt(T(2))*exp(x^2*(-50)*314_159/100_000)
    expect = BigFloat("5.0000021117e-1")

    I, E = quadde32(f, 0, 0.5, 10)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 0.5, 10)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-10
    I, E = quaddeBF(f, 0, 0.5, 10, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol*2)
    @test E ≤ rtol*norm(I)
end


# Test problem 15
# Super fast decay around x ~ 0
# FIXME: split the integral range into parts
let
    f(x::AbstractFloat) = 25*exp(-x*25)
    expect = 1

    I, E = quadde32(f, 0, 1, 10)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1, 10)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, 10, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol*2)
    @test E ≤ rtol*norm(I)
end


# Test problem 16
# Super fast decay around x ~ 0
let
    f(x::AbstractFloat) = 1/(2500*x^2 + 1)*50/314_159*100_000
    expect = BigFloat("4.99363802871016550828171090341e-1")

    I, E = quadde32(f, 0, 10)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 10)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 10, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 17
# Attenuating oscillation
let
    f(x::AbstractFloat) = (sin(x*50*314_159/100_000)/(x*50*314_159/100_000))^2*50
    expect = BigFloat("1.12139569626709460839885e-1")

    I, E = quadde32(f, 0.01, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0.01, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    # NOTE: the accuracy is not improved so much?
    rtol = 1e-16
    I, E = quaddeBF(f, 0.01, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 18
# Oscillating function
# NOTE: expect value is doubtful?
let
    f(x::AbstractFloat) = cos(cos(x) + 3*sin(x) + 2*cos(2x) + 3*sin(2x) + 3*cos(3x))
    expect = BigFloat("8.386763233809718250439e-1")

    I, E = quadde32(f, 0, π)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, π)
    @test I isa Float64
    @test_broken I ≈ expect
    @test_skip E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-11
    I, E = quaddeBF(f, 0, π, rtol=rtol)
    @test I isa BigFloat
    @test_broken isapprox(I, expect, rtol=rtol)
    @test_skip E ≤ rtol*norm(I)
end


# Test problem 19
let
    f(x::AbstractFloat) = log(x)
    expect = -1

    I, E = quadde32(f, 0, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 20
let
    f(x::T) where {T<:AbstractFloat} = 1/(x^2 + T(1.005))
    f(x::BigFloat) = 1/(x^2 + BigFloat("1.005"))
    expect = BigFloat("1.5643964440690497730914930158085e0")

    I, E = quadde32(f, -1, 1)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, -1, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end


# Test problem 21
# including spikes
# FIXME: split the integral range into parts
let
    f(x::AbstractFloat) = 1/cosh((10x-2))^2+1/cosh((100x-40))^4+1/cosh((1000x-600))^6
    expect = BigFloat("0.2108027355005492773756")

    I, E = quadde32(f, 0, 0.3, 0.5, 1, rtol=1e-6)
    @test I isa Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    I, E = quadde64(f, 0, 0.3, 0.5, 1)
    @test I isa Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(I))*norm(I)

    rtol = 1e-21
    I, E = quaddeBF(f, 0, 0.3, 0.5, 1, rtol=rtol)
    @test I isa BigFloat
    @test isapprox(I, expect, rtol=10rtol*3)
    @test E ≤ rtol*norm(I)
end


# Test non-scalar output with QuadDE
let
    f(x::AbstractFloat) = [1/(1 + x^2), 2/(1 + x^2)]
    expect = [BigFloat(π)/2, BigFloat(π)]

    I, E = quadde32(f, -1, 1)
    @test eltype(I) == Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    I, E = quadde64(f, -1, 1)
    @test eltype(I) == Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 1, rtol=rtol)
    @test eltype(I) == BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)


    I, E = quadde32(f, -1, 0, 1)
    @test eltype(I) == Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    I, E = quadde64(f, -1, 0, 1)
    @test eltype(I) == Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -1, 0, 1, rtol=rtol)
    @test eltype(I) == BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)


    f(x::AbstractFloat) = [exp(-x), 2exp(-x)]
    expect = [1, 2]

    I, E = quadde32(f, 0, Inf)
    @test eltype(I) == Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    I, E = quadde64(f, 0, Inf)
    @test eltype(I) == Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, 0, Inf, rtol=rtol)
    @test eltype(I) == BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)


    f(x::AbstractFloat) = [exp(-x^2), 2*exp(-x^2)]
    expect = [sqrt(BigFloat(π)), 2*sqrt(BigFloat(π))]

    I, E = quadde32(f, -Inf, Inf)
    @test eltype(I) == Float32
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    I, E = quadde64(f, -Inf, Inf)
    @test eltype(I) == Float64
    @test I ≈ expect
    @test E ≤ sqrt(eps(eltype(I)))*norm(I)

    rtol = 1e-30
    I, E = quaddeBF(f, -Inf, Inf, rtol=rtol)
    @test eltype(I) == BigFloat
    @test isapprox(I, expect, rtol=10rtol)
    @test E ≤ rtol*norm(I)
end
