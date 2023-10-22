using AlgebraicVision
using Documenter

DocMeta.setdocmeta!(AlgebraicVision, :DocTestSetup, :(using AlgebraicVision); recursive=true)

makedocs(;
    modules=[AlgebraicVision],
    authors="Viktor Korotynskiy <korotynskiy.viktor@gmail.com> and contributors",
    repo="https://multivariatepolynomialsystems.github.io/AlgebraicVision.jl/blob/{commit}{path}#{line}",
    sitename="AlgebraicVision.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://multivariatepolynomialsystems.github.io/AlgebraicVision.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MultivariatePolynomialSystems/AlgebraicVision.jl.git",
    devbranch="main",
)
