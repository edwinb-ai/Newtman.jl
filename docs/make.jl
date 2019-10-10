using Documenter, Newtman

makedocs(;
    modules=[Newtman],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Types" => "benchmarks.md",
    ],
    repo="https://gitlab.com/developEdwin/Newtman.jl/blob/{commit}{path}#L{line}",
    sitename="Newtman.jl",
    authors="Edwin Bedolla",
    assets=String[],
)

deploydocs(
    repo="https://gitlab.com/developEdwin/newtman.jl.git",
    branch="pages",
)
