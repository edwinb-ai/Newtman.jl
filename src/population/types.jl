"""
"""
abstract type Individual end

export Particle, Population

"""
"""
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
"""
Particle(x::T, v::T, x_best::T, a::V, b::V) where {T<:AbstractArray, V<:AbstractFloat} =
    Particle{T, V}(x, v, x_best, a, b)

"""
"""
function _particle(a::T, b::T, n::V) where {T<:AbstractFloat, V<:Int}
    @assert n > 0 "Dimension is always positive"

    x = a .+ (rand(T, n) * (b - a))
    v = a .+ (rand(T, n) * (b - a))
    x_best = rand(T, n)
    new_particle = Particle(x, v, x_best, a, b)

    return new_particle
end

"""
"""
mutable struct Population end

"""
"""
function Population(dim, a, b)
    container = Vector{Particle}(undef, dim)
    for idx in eachindex(container)
        container[idx] = _particle(a, b, dim)
    end
    return container
end