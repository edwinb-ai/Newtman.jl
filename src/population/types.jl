"""
    Individual

Abstract super-type for types that contain their own information.
"""
abstract type Individual end

export Particle, Population

mutable struct Particle{T<:AbstractArray, V<:AbstractFloat} <: Individual
    x::T
    v::T
    x_best::T
    min_dim::V
    max_dim::V

    function Particle{T, V}(x::T, v::T, x_best::T, a::V, b::V) where
        {T<:AbstractArray, V<:AbstractFloat}

        @assert length(x) == length(v) == length(x_best) "Dimension must be unique"

        return new(x, v, x_best, a, b)
    end
end

"""
    Particle(x::T, v::T, x_best::T, a::V, b::V) where {T<:AbstractArray, V<:AbstractFloat}

A type that can hold information about current position, current velocity,
the _best_ candidate to a solution, as well as defining the bounds.
The dimensions of the `Particle` are inferred from the length of the arrays.

# Arguments
- `x`: Array that holds the **positions** of possible solutions.
- `v`: Array that holds **velocities** related to `x`.
- `x_best`: An element of `x` that determines the best position for the particle.
- `a`: lower bound for `x`
- `b`: upper bound for `v`

# Example
```julia
p = Particle(zeros(3), rand(3), zeros(3), -1.0, 1.0)
```
"""
Particle(x::T, v::T, x_best::T, a::V, b::V) where {T<:AbstractArray, V<:AbstractFloat} =
    Particle{T, V}(x, v, x_best, a, b)

"""
    Particle(a::T, b::T, n::V) where {T<:AbstractFloat, V<:Int}

`Particle` that can be created randomly using the bounds and the dimension needed.

# Arguments
- `a`: lower bound for `x`
- `b`: upper bound for `v`
- `n`: dimension for `x`, `v`, and `x_best`.

# Example
```julia
p = Particle(-1.0, 1.0, 3)
```
"""
function Particle(a::T, b::T, n::V) where {T<:AbstractFloat, V<:Int}
    @assert n > 0 "Dimension is always positive"

    x = a .+ (rand(T, n) * (b - a))
    v = a .+ (rand(T, n) * (b - a))
    x_best = rand(T, n)

    return Particle(x, v, x_best, a, b)
end

mutable struct Population end

"""
    Population
"""
function Population(num_particles::T, dim::T, a::V, b::V) where {T<:Int, V<:AbstractFloat}
    @assert dim > 0 "Dimension is always positive"
    @assert num_particles > 0 "There must be at least 1 Particle in the Population"

    container = Vector{Particle}(undef, num_particles)
    for idx in eachindex(container)
        container[idx] = Particle(a, b, dim)
    end

    return container
end

"""
    Population
"""
function Population(dim::T, a::V, b::V) where {T<:Int, V<:AbstractFloat}
    @assert dim > 0 "Dimension is always positive"

    container = Vector{Particle}(undef, 5)
    for idx in eachindex(container)
        container[idx] = Particle(a, b, dim)
    end

    return container
end
