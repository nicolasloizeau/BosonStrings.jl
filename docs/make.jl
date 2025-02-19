using BosonStrings
using Documenter

DocMeta.setdocmeta!(BosonStrings, :DocTestSetup, :(using BosonStrings); recursive=true)

makedocs(;
    modules=[BosonStrings],
    authors="Nicolas Loizeau",
    sitename="BosonStrings.jl",
    format=Documenter.HTML(;
        canonical="https://nicolasloizeau.github.io/BosonStrings.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/nicolasloizeau/BosonStrings.jl",
    devbranch="main",
)
