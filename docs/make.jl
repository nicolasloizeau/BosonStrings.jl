using BosonStrings
using Documenter


readme_str = read(joinpath(@__DIR__, "..", "README.md"), String)
write(
  joinpath(@__DIR__, "src", "index.md"),
  replace(readme_str, "./docs/src/assets/" => "assets/"),
)



DocMeta.setdocmeta!(BosonStrings, :DocTestSetup, :(using BosonStrings); recursive=true)

makedocs(
    modules=[BosonStrings],
    authors="Nicolas Loizeau",
    sitename="BosonStrings.jl",
    format=Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical="https://nicolasloizeau.github.io/BosonStrings.jl",
        edit_link="main",
        assets=String[],
    ),
    pages = [
        "Getting started" => "index.md",
        "Tutorials" => ["Constructing operators"=>"constructing.md",
                        "Time evolution"=>"evolution.md"],
        "Documentation" => "docstrings.md"]
)

deploydocs(
    repo = "github.com/nicolasloizeau/BosonStrings.jl.git",
    devbranch = "main",
    branch = "gh-pages",
)
