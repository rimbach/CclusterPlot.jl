VERSION >= v"0.4.0-dev+6521" && __precompile__()

module CclusterPlot

import Nemo: fmpq 
import Ccluster: box

# using Ccluster
using PyCall
using PyPlot

const matplotlib_patches = PyNULL()

function __init__()
    println("")
    println("Welcome to CclusterPlot version 0.0.1")
    println("")
    
    copy!(matplotlib_patches, pyimport_conda("matplotlib.patches", "matplotlib"))
end

__init__()

include("plotCcluster.jl")
export plotCcluster

end # module
