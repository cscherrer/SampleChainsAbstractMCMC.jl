using SampleChainsAbstractMCMC
using Documenter

DocMeta.setdocmeta!(SampleChainsAbstractMCMC, :DocTestSetup, :(using SampleChainsAbstractMCMC); recursive=true)

makedocs(;
    modules=[SampleChainsAbstractMCMC],
    authors="Chad Scherrer <chad.scherrer@gmail.com> and contributors",
    repo="https://github.com/cscherrer/SampleChainsAbstractMCMC.jl/blob/{commit}{path}#{line}",
    sitename="SampleChainsAbstractMCMC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cscherrer.github.io/SampleChainsAbstractMCMC.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cscherrer/SampleChainsAbstractMCMC.jl",
)
