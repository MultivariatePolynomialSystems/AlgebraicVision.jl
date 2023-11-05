# AlgebraicVision.jl

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://multivariatepolynomialsystems.github.io/AlgebraicVision.jl/stable/)-->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://multivariatepolynomialsystems.github.io/AlgebraicVision.jl/dev/)

AlgebraicVision.jl is a Julia package that generates an algebraic problem in geometric computer vision as a polynomial system depending on the setup of cameras that observe the scene and the scene itself.

## Installation

Enter the Pkg REPL by pressing `]` from the Julia REPL and then type
```julia
add https://github.com/MultivariatePolynomialSystems/AlgebraicVision.jl.git
```
To get back to the Julia REPL, press backspace.

## Usage
### Vision Problem Formulation
```julia
using AlgebraicVision
radial_4v = VisionProblem(
    cameras = CamerasSetup(
        ncameras = 4,
        camera_types = :radial,
        calibration = :calibrated
    ),
    scene = SceneSetup(
        npoints = 13,
        nlines = 0,
        incidences = []
    ),
    formulation = Formulation(
        rotations = :cayley,
        pose = :rel
    )
)
```
The result of the `VisionProblem` constructor is an object of type `VisionProblem` that is formulated by a polynomial system. The polynomial system can be viewed as
```julia
radial_4v.equations
```
```
System of length 104
 111 variables: c₁₋₁, c₂₋₁, c₃₋₁, c₁₋₂, c₂₋₂, c₃₋₂, c₁₋₃, c₂₋₃, c₃₋₃, c₁₋₄, c₂₋₄, c₃₋₄, t₁₋₁, t₂₋₁, t₁₋₂, t₂₋₂, t₁₋₃, t₂₋₃, t₁₋₄, t₂₋₄, α₁₋₁, α₂₋₁, α₃₋₁, α₄₋₁, α₅₋₁, α₆₋₁, α₇₋₁, α₈₋₁, α₉₋₁, α₁₀₋₁, α₁₁₋₁, α₁₂₋₁, α₁₃₋₁, α₁₋₂, α₂₋₂, α₃₋₂, α₄₋₂, α₅₋₂, α₆₋₂, α₇₋₂, α₈₋₂, α₉₋₂, α₁₀₋₂, α₁₁₋₂, α₁₂₋₂, α₁₃₋₂, α₁₋₃, α₂₋₃, α₃₋₃, α₄₋₃, α₅₋₃, α₆₋₃, α₇₋₃, α₈₋₃, α₉₋₃, α₁₀₋₃, α₁₁₋₃, α₁₂₋₃, α₁₃₋₃, α₁₋₄, α₂₋₄, α₃₋₄, α₄₋₄, α₅₋₄, α₆₋₄, α₇₋₄, α₈₋₄, α₉₋₄, α₁₀₋₄, α₁₁₋₄, α₁₂₋₄, α₁₃₋₄, X₁₋₁, X₂₋₁, X₃₋₁, X₁₋₂, X₂₋₂, X₃₋₂, X₁₋₃, X₂₋₃, X₃₋₃, X₁₋₄, X₂₋₄, X₃₋₄, X₁₋₅, X₂₋₅, X₃₋₅, X₁₋₆, X₂₋₆, X₃₋₆, X₁₋₇, X₂₋₇, X₃₋₇, X₁₋₈, X₂₋₈, X₃₋₈, X₁₋₉, X₂₋₉, X₃₋₉, X₁₋₁₀, X₂₋₁₀, X₃₋₁₀, X₁₋₁₁, X₂₋₁₁, X₃₋₁₁, X₁₋₁₂, X₂₋₁₂, X₃₋₁₂, X₁₋₁₃, X₂₋₁₃, X₃₋₁₃
 104 parameters: l₁₋₁₋₁, l₂₋₁₋₁, l₁₋₂₋₁, l₂₋₂₋₁, l₁₋₃₋₁, l₂₋₃₋₁, l₁₋₄₋₁, l₂₋₄₋₁, l₁₋₅₋₁, l₂₋₅₋₁, l₁₋₆₋₁, l₂₋₆₋₁, l₁₋₇₋₁, l₂₋₇₋₁, l₁₋₈₋₁, l₂₋₈₋₁, l₁₋₉₋₁, l₂₋₉₋₁, l₁₋₁₀₋₁, l₂₋₁₀₋₁, l₁₋₁₁₋₁, l₂₋₁₁₋₁, l₁₋₁₂₋₁, l₂₋₁₂₋₁, l₁₋₁₃₋₁, l₂₋₁₃₋₁, l₁₋₁₋₂, l₂₋₁₋₂, l₁₋₂₋₂, l₂₋₂₋₂, l₁₋₃₋₂, l₂₋₃₋₂, l₁₋₄₋₂, l₂₋₄₋₂, l₁₋₅₋₂, l₂₋₅₋₂, l₁₋₆₋₂, l₂₋₆₋₂, l₁₋₇₋₂, l₂₋₇₋₂, l₁₋₈₋₂, l₂₋₈₋₂, l₁₋₉₋₂, l₂₋₉₋₂, l₁₋₁₀₋₂, l₂₋₁₀₋₂, l₁₋₁₁₋₂, l₂₋₁₁₋₂, l₁₋₁₂₋₂, l₂₋₁₂₋₂, l₁₋₁₃₋₂, l₂₋₁₃₋₂, l₁₋₁₋₃, l₂₋₁₋₃, l₁₋₂₋₃, l₂₋₂₋₃, l₁₋₃₋₃, l₂₋₃₋₃, l₁₋₄₋₃, l₂₋₄₋₃, l₁₋₅₋₃, l₂₋₅₋₃, l₁₋₆₋₃, l₂₋₆₋₃, l₁₋₇₋₃, l₂₋₇₋₃, l₁₋₈₋₃, l₂₋₈₋₃, l₁₋₉₋₃, l₂₋₉₋₃, l₁₋₁₀₋₃, l₂₋₁₀₋₃, l₁₋₁₁₋₃, l₂₋₁₁₋₃, l₁₋₁₂₋₃, l₂₋₁₂₋₃, l₁₋₁₃₋₃, l₂₋₁₃₋₃, l₁₋₁₋₄, l₂₋₁₋₄, l₁₋₂₋₄, l₂₋₂₋₄, l₁₋₃₋₄, l₂₋₃₋₄, l₁₋₄₋₄, l₂₋₄₋₄, l₁₋₅₋₄, l₂₋₅₋₄, l₁₋₆₋₄, l₂₋₆₋₄, l₁₋₇₋₄, l₂₋₇₋₄, l₁₋₈₋₄, l₂₋₈₋₄, l₁₋₉₋₄, l₂₋₉₋₄, l₁₋₁₀₋₄, l₂₋₁₀₋₄, l₁₋₁₁₋₄, l₂₋₁₁₋₄, l₁₋₁₂₋₄, l₂₋₁₂₋₄, l₁₋₁₃₋₄, l₂₋₁₃₋₄
```
As we can see, it containts the rotation cayley coordinates `cᵢ₋ⱼ`, translation coordinates `tᵢ₋ⱼ`, depths `αᵢ₋ⱼ` of 3D points, the 3D points' coordinates `Xᵢ₋ⱼ`, and finally the coordinates of the projections of 3D points into the cameras `xᵢ₋ⱼ₋ₖ`.