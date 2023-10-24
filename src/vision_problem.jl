export vision_problem

using LinearAlgebra: I, det

rotation_constraints(R::Matrix{Variable}) = vcat((R'*R-I)[:], det(R)-1)

function rotation_constraints(R::Array{Variable, 3})
    return vcat([rotation_constraints(R[:,:,i]) for i in axes(R,3)]...)
end

function abs_pose_eqs(nviews::Int, npoints::Int)
    eqs = nothing
    if nviews == 1
        @var R[1:3,1:3] t[1:3] α[1:npoints] x[1:3,1:npoints] X[1:3,1:npoints]
        eqs = vcat([α[i]*x[:,i] - [R t]*[X[:,i]; 1] for i in 1:npoints]...)
    else
        @var R[1:3,1:3,1:nviews] t[1:3,1:nviews] α[1:npoints,1:nviews]
        @var x[1:3,1:npoints,1:nviews] X[1:3,1:npoints]
        eqs = vcat([α[i,j]*x[:,i,j] - [R[:,:,j] t[:,j]]*[X[:,i]; 1] for i in 1:npoints for j in 1:nviews]...)
    end
    append!(eqs, rotation_constraints(R))
    return System(eqs; variables=vcat(R[:], t[:], α[:]), parameters=vcat(x[:], X[:]))
end

function rel_pose_eqs(nviews::Int, npoints::Int; fix_world::Bool=true)
    nviews == 1 && throw(ArgumentError("Number of views for relative pose must be at least 2"))
    eqs = nothing
    if fix_world
        if nviews == 2
            @var R[1:3,1:3] t[1:3] α[1:npoints] β[1:npoints] x[1:3,1:npoints] y[1:3,1:npoints]
            eqs = vcat([β[i]*y[:,i] - [R t]*[α[i]*x[:,i]; 1] for i in 1:npoints]...)
            append!(eqs, rotation_constraints(R))
            return System(eqs; variables=vcat(R[:], t, α, β), parameters=vcat(x[:], y[:]))
        else
            @var R[1:3,1:3,2:nviews] t[1:3,2:nviews]
            @var α[1:npoints,1:nviews] x[1:3,1:npoints,1:nviews]
            eqs = vcat([α[i,j]*x[:,i,j] - [R[:,:,j-1] t[:,j-1]]*[α[i,1]*x[:,i,1]; 1] for i in 1:npoints for j in 2:nviews]...)
            append!(eqs, rotation_constraints(R))
            return System(eqs; variables=vcat(R[:], t[:], α[:]), parameters=x[:])
        end
    else
        @var R[1:3,1:3,1:nviews] t[1:3,1:nviews] X[1:3,1:npoints]
        @var α[1:npoints,1:nviews] x[1:3,1:npoints,1:nviews]
        eqs = vcat([α[i,j]*x[:,i,j] - [R[:,:,j] t[:,j]]*[X[:,i]; 1] for i in 1:npoints for j in 1:nviews]...)
        append!(eqs, rotation_constraints(R))
        return System(eqs; variables=vcat(R[:], t[:], α[:], X[:]), parameters=x[:])
    end
end

function vision_problem(; nviews::Int, npoints::Int, pose::Symbol=:rel, fix_world::Bool=true)
    nviews <= 0 && throw(ArgumentError("Number of views must be positive"))
    npoints <= 0 && throw(ArgumentError("Number of points must be positive"))
    if pose == :rel
        return rel_pose_eqs(nviews, npoints, fix_world=fix_world)
    elseif pose == :abs
        return abs_pose_eqs(nviews, npoints)
    else
        throw(ArgumentError("Unknown pose"))
    end
end
