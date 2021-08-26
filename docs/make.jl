using Documenter
using MainPaths

makedocs(
    sitename = "MainPaths",
    format = Documenter.HTML(),
    modules = [MainPaths]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/jfb-h/MainPaths.jl.git"
)
