module SampleChainsAbstractMCMC

using SampleChains
using AbstractMCMC




using Reexport
@reexport using SampleChains
using ConcreteStructs
using Random
using TupleVectors

using TupleVectors: chainvec

export AbstractMCMCChain

@concrete struct  AbstractMCMCChain{T} <: AbstractChain{T}
    samples     # :: AbstractVector{T}
    info        # Per-sample metadata, type depends on sampler used
    meta        # Metadata associated with the sample as a whole
    state       
    transform
end

function AbstractMCMCChain(samples::AbstractVector{T}, info, meta, state, transform) where {T}
    return AbstractMCMCChain{T}(samples, info, meta, state, transform)
end

TupleVectors.summarize(ch::AbstractMCMCChain) = summarize(samples(ch))

function gettransform(chain::AbstractMCMCChain)
    return getfield(chain, :transform)
end

function SampleChains.pushsample!(chain::AbstractMCMCChain, val, state)
    tr = getfield(chain, :transform)
    samplemap = tr.samplemap
    statemap = tr.statemap

    push!(samples(chain), samplemap(val))
    push!(info(chain), statemap(state))
end

function SampleChains.step!(chain::AbstractMCMCChain)
    st = getfield(chain, :state)
    mt = getfield(chain, :meta)
    rng = st.rng
    state = st.state[]
    model = mt.model
    sampler = mt.sampler
    val, state = AbstractMCMC.step(rng, model, sampler, state)
end

function SampleChains.initialize!(rng::Random.AbstractRNG, ::Type{AbstractMCMCChain}, model::AbstractMCMC.AbstractModel, spl::AbstractMCMC.AbstractSampler, samplemap, statemap)
    (val, state) = AbstractMCMC.step(rng, model, spl)

    sample0 = samplemap(val)
    info0 = statemap(state)

    samples = chainvec(sample0)
    info = chainvec(info0)
    meta = (model = model, sampler = spl)
    state = (rng=rng, state=Ref(state))
    transform = (samplemap=samplemap, statemap=statemap)
    
    AbstractMCMCChain(samples, info, meta, state, transform)
end

function SampleChains.initialize!(::Type{AbstractMCMCChain}, model::AbstractMCMC.AbstractModel, spl::AbstractMCMC.AbstractSampler, samplemap, statemap)
    rng = Random.GLOBAL_RNG
    return initialize!(rng, AbstractMCMCChain, model, spl, samplemap, statemap)
end

function SampleChains.drawsamples!(chain::AbstractMCMCChain, n::Int=1000)
    @cleanbreak for j in 1:n
        val, state = step!(chain)
        pushsample!(chain, val, state)
    end 
    return chain
end

end
