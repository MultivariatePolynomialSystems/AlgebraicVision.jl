export VisionProblem,
    CamerasSetup,
    SceneSetup,
    Formulation

using LinearAlgebra: I, det

# subs(VP, x[:,1] => [0,0,0], t[:,1] => [0,0], t[:,2] => [0,1])

const CAMERA_TYPES = [:perspective, :radial]
const CAMERA_POSES = [:rel, :abs]
const ROTATION_PARAMETRIZATIONS = [:explicit, :cayley, :quaternion]

@kwdef struct CamerasSetup
    ncameras::Int
    camera_types::Union{Symbol, Vector{Symbol}}=:perspective
    calibration::Symbol=:calibrated
end

@kwdef struct Formulation
    pose::Symbol=:rel
    rotations::Union{Symbol, Vector{Symbol}}=:explicit
end

abstract type PointLineIncidence end

@kwdef struct SceneSetup
    npoints::Int
    nlines::Int=0
    incidences::Vector{PointLineIncidence}=[]
end

function rotation_constraints(R::Matrix{Variable})
    if size(R, 1) == 3
        return vcat((R*R'-I)[:], det(R)-1)
    else
        return (R*R'-I)[:]
    end
end

function rotation_constraints(R::Array{Variable, 3})
    return vcat([rotation_constraints(R[:,:,i]) for i in axes(R,3)]...)
end

function equations(cameras::CamerasSetup, scene::SceneSetup, formulation::Formulation)
    @unpack ncameras, camera_types = cameras
    @unpack npoints, nlines, incidences = scene
    @unpack pose, rotations = formulation
    @var t[1:3,1:ncameras] α[1:npoints,1:ncameras] X[1:3,1:npoints]
    if rotations == :explicit
        @var R[1:3,1:3,1:ncameras]
        P = [[R[:,:,i] t[:,i]] for i in 1:ncameras]
    elseif rotations == :cayley
        @var c[1:3,1:ncameras]
        P = [ct2sP(c[:,i], t[:,i]) for i in 1:ncameras]
    end
    if camera_types == :perspective
        @var x[1:3,1:npoints,1:ncameras]
    elseif camera_types == :radial
        if rotations == :explicit
            R = R[1:2,:,:]
        end
        t = t[1:2,:]
        P = [P[i][1:2,:] for i in 1:ncameras]
        @var l[1:2,1:npoints,1:ncameras]
        x = l
    end
    eqs = vcat([α[i,j]*x[:,i,j] - P[j]*[X[:,i]; 1] for i in 1:npoints for j in 1:ncameras]...)
    if rotations == :explicit
        append!(eqs, rotation_constraints(R))
        if pose == :abs
            return System(eqs; variables=vcat(R[:], t[:], α[:]), parameters=vcat(x[:], X[:]))
        elseif pose == :rel
            return System(eqs; variables=vcat(R[:], t[:], α[:], X[:]), parameters=x[:])
        end
    elseif rotations == :cayley
        if pose == :abs
            return System(eqs; variables=vcat(c[:], t[:], α[:]), parameters=vcat(x[:], X[:]))
        elseif pose == :rel
            return System(eqs; variables=vcat(c[:], t[:], α[:], X[:]), parameters=x[:])
        end
    end
end

struct VisionProblem
    cameras::CamerasSetup
    scene::SceneSetup
    formulation::Formulation
    equations::System
end

function check_args(cameras::CamerasSetup)
    @unpack ncameras, camera_types = cameras
    ncameras <= 0 && throw(ArgumentError("Number of cameras must be positive"))
    if !(camera_types in CAMERA_TYPES)
        throw(ArgumentError("Unknown camera type"))
    end
end

function check_args(scene::SceneSetup)
    @unpack npoints, nlines, incidences = scene
    npoints+nlines <= 0 && throw(ArgumentError("Total number of points and lines must be positive"))
    # TODO: check incidences
end

function check_args(formulation::Formulation)
    @unpack pose, rotations = formulation
    if !(pose in CAMERA_POSES)
        throw(ArgumentError("Unknown camera pose"))
    end
    if !(rotations in ROTATION_PARAMETRIZATIONS)
        throw(ArgumentError("Unknown rotation parametrization"))
    end
end

function VisionProblem(;
    cameras::CamerasSetup,
    scene::SceneSetup,
    formulation::Formulation=Formulation()
)
    check_args(cameras)
    check_args(scene)
    check_args(formulation)
    eqs = equations(cameras, scene, formulation)
    return VisionProblem(cameras, scene, formulation, eqs)
end

function fabricateSample(vp::VisionProblem)

end

function HC.subs(vp::VisionProblem, substitutions::Pair...)

end