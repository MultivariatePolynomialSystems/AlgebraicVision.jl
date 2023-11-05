module AlgebraicVision

using UnPack: @unpack
import HomotopyContinuation
const HC = HomotopyContinuation
using HomotopyContinuation.ModelKit
export @var, Variable, Expression, System

include("utils.jl")
include("vision_problem.jl")

end