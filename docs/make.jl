using Documenter
using Newtman, Newtman.TestFunctions
using Literate

# ! Convert scripts to markdown using Literate
files = ["examples.jl"]

function lit_to_md(file)
    examples_path = joinpath("src", "examples")
    out_md_path = "src"
    Literate.markdown(
        joinpath(examples_path, file),
        out_md_path;
        documenter = true
    )
end

map(lit_to_md, files)

# ! Build the full Documentation with Documenter
makedocs(;
    modules = [Newtman, Newtman.TestFunctions],
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://edwinb-ai.github.io/Newtman.jl/stable/",
        assets=String[],
    ),
    pages = [
        "Home" => "index.md",
        "Guide" => "guide.md",
        "Examples" => "examples.md",
        "Implementations" => "algorithms.md",
        "Benchmark functions" => "benchmarks.md",
        "Reference" => "reference.md",
        "License" => "license.md",
    ],
    repo="https://github.com/edwinb-ai/Newtman.jl/blob/{commit}{path}#L{line}",
    sitename = "Newtman.jl",
    authors = "Edwin Bedolla"
)

deploydocs(
    repo = "github.com/edwinb-ai/Newtman.jl.git",
    push_preview=true
)
