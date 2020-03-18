using Documenter, Newtman

makedocs(;
    modules = [Newtman],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Guide" => "guide.md",
        "Implementations" => "algorithms.md",
        "Benchmark functions" => "benchmarks.md",
        "Reference" => "reference.md",
        "License" => "license.md",
    ],
    sitename = "Newtman.jl",
    authors = "Edwin Bedolla",
)

deploydocs(
    repo = "github.com/edwinb-ai/Newtman.jl.git"
)
