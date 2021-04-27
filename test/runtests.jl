using SampleChainsAbstractMCMC
using Test

@testset "SampleChainsAbstractMCMC.jl" begin
    # Import the package.
    using AdvancedMH
    using AbstractMCMC

    # Generate a set of data from the posterior we want to estimate.
    data = rand(Normal(0, 1), 30);

    # Define the components of a basic model.
    insupport(θ) = θ[2] >= 0;
    # dist(θ) = Normal(θ[1], θ[2]);
    ℓ(θ,x) = -log(θ[2]) - sum(δ -> δ^2, θ[1] .- x)/θ[2]
    density(θ) = insupport(θ) ? ℓ(θ,data) : -Inf;

    # Construct a DensityModel.
    model = DensityModel(density);

    # Set up our sampler with a joint multivariate Normal proposal.
    spl = RWMH(MvNormal(2,1));

    using SampleChainsAbstractMCMC

    chain = initialize!(AbstractMCMCChain, model, spl, x -> (x = x.params[1], y=x.params[2]), x -> x.params)
    drawsamples!(chain, 9999)
end
