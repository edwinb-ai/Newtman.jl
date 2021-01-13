import Newtman.TestFunctions: Benchmark, evaluate

"""
    PSO

`PSO` is the type associated with the implementation for the
Particle Swarm Optimization with momentum. See [`Algorithms`](@ref implementations-docs)
for more information.
"""
struct PSO <: PopulationBase end

"""
    PSO(f::Function, population::AbstractArray, k_max::Int;
        w=0.9, c1=2.0, c2=2.0, seed = nothing
    ) -> OptimizationResults
    PSO(f::Benchmark, population::AbstractArray, k_max::Int;
        w=0.9, c1=2.0, c2=2.0, seed = nothing
    ) -> OptimizationResults

Method that implements `PSO` for a function `f` of type `Function`
or of type `Benchmark`.
Returns an `OptimizationResults` type with information relevant to the
run executed, see [`OptimizationResults`](@ref).

# Arguments

- `population`: can be any `AbstractArray` that contains [`Particle`](@ref)
instances, but it is expected to be generated by [`Population`](@ref).
- `k_max`: number of maximum iterations until "convergence" of the algorithm.

# Keyword arguments

_It is recommended to use the default values provided._

- `w`: value that controls how much of the initial velocity is retained, i.e.
an inertia term. This values decays linearly over each iteration until it reaches
the default miminum value of 0.4.
- `c1`: balance between the influence of the individual's knowledge, i.e. the
best inidividual solution so far.
- `c2`: balance between the influence of the population's knowledge, i.e. the
best global solution so far.
- `seed`: an integer to be used as the seed for the pseudo random number generators.
If `nothing` is passed (the default), then a random seed will be taken from the
system.

# Examples
```julia
using Newtman

# Define the Sphere function
f_sphere(x) = sum(x .^ 2)

# Implement PSO for a 3-dimensional Sphere function, with
# 10000 iterations and 30 particles in the population.
val = PSO(f_sphere, Population(30, 3, -15.0, 15.0), 10000)
```
"""
function PSO(f::Function, population::AbstractArray, k_max::Int;
    w = 0.9, c1 = 2.0, c2 = 2.0, seed = nothing)

    val = _pso!(f, population, k_max; w = w, c1 = c1, c2 = c2, seed = seed)

    optim_res = OptimizationResults(val,
                f(val),
                "PSO",
                k_max)
    return optim_res
end

function PSO(f::Benchmark, population::AbstractArray, k_max::Int;
    w = 0.9, c1 = 2.0, c2 = 2.0, seed = nothing)

    val = _pso!(
        x->evaluate(f, x),
        population,
        k_max;
        w = w,
        c1 = c1,
        c2 = c2,
        seed = seed
    )

    optim_res = OptimizationResults(val,
                evaluate(f, val),
                "PSO",
                k_max)
    return optim_res
end

function _pso!(f, population::AbstractArray, k_max::Int;
    w = 0.9, c1 = 2.0, c2 = 2.0, seed = nothing)

    # Create the RNG generator with the specified seed
    if isnothing(seed)
        rng = Xorshifts.Xoroshiro128Plus()
    else
        rng = Xorshifts.Xoroshiro128Plus(seed)
    end

    # Obtain weight decay rate
    η = _weight_decay(w, k_max)

    # Evaluate initial costs
    dimension = length(population[1].x)

    # Initialize container variables
    x_best = similar(population[1].x_best)
    y_best = Inf
    for P in population
        y = f(P.x)
        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
    end

    # PSO main loop
    for k in 1:k_max
        _update!(f, population, w, c1, c2, dimension, x_best, y_best, rng)
        # Make the inertia weight decay over time
        w -= η
    end

    # Always return the first position as it contains the best possible
    # solution
    return population[1].x_best
end

function _update!(f, population, w, c1, c2, n, x_best, y_best, rng)

    for P in population
        rngs = rand(rng, n, 2)
        # Evaluate velocity
        P.v = (w * P.v) + (c1 * rngs[:, 1] .* (P.x_best - P.x)) +
            (c2 * rngs[:, 2] .* (x_best - P.x))
        # Update position
        P.x += P.v
        # Apply boundary values to positions and velocities
        _clip_positions_velocities!(P)
        # Update values if they give lower cost
        y = f(P.x)
        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
        if y < f(P.x_best)
            P.x_best[:] = P.x
        end
    end
end


function _weight_decay(initial, itr_max)
""" Compute the corresponding weight decay depending the maximum
number of iterations and the initial value for it.
"""
    # Following the references, the minimum is 0.4
    stop = 0.4
    step_size = (initial - stop) / itr_max

    return step_size
end


function _clip_positions_velocities!(P)
""" Apply boundary conditions to both position and velocity for
every `Particle` type object `P`.
"""
    # First the positions
    # upper bound
    broadcast!(x->x > P.max_dim ? P.max_dim : x, P.x, P.x)
    # lower bound
    broadcast!(x->x < P.min_dim ? P.min_dim : x, P.x, P.x)

    # Then the velocities
    # upper bound
    broadcast!(x->x > P.max_dim ? P.max_dim : x, P.v, P.v)
    # lower bound
    broadcast!(x->x < P.min_dim ? P.min_dim : x, P.v, P.v)
end
