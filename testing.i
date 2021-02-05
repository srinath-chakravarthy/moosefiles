[Mesh]
  file = mat_fiber.msh
  use_displaced_mesh = false
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[Functions]
  [./Exx]
    type = PiecewiseLinear
    x = '0. 0.5 1 '
    y = '0 0.3 0'
  [../]
  [./Exy]
    type = PiecewiseLinear
    x = '0 1'
    y = '0 0' 
  [../]
  [./Eyy]
    type = PiecewiseLinear
    x = '0 1'
    y = '0 0' 
  [../]
  [./bot_displacement_x]
    type = ParsedFunction
    value = Exx*x
    vars = 'Exx'
    vals = 'Exx'
  [../]
  [./bot_displacement_y]
    type = ParsedFunction
    value = Exy*x
    vars = 'Exy'
    vals = 'Exy'
  [../]
  [./left_displacement_x]
    type = ParsedFunction
    value = Exy*y
    vars = 'Exy'
    vals = 'Exy'
  [../]
  [./left_displacement_y]
    type = ParsedFunction
    value = Eyy*y
    vars = 'Eyy'
    vals = 'Eyy'
  [../]
  [./top_displacement_x]
    type = ParsedFunction
    value = Exx*x+Exy
    vars = 'Exx Exy'
    vals = 'Exx Exy'
  [../]
  [./top_displacement_y]
    type = ParsedFunction
    value = Exy*x+Eyy
    vars = 'Exy Eyy'
    vals = 'Exy Eyy'
  [../]
  [./right_displacement_x]
    type = ParsedFunction
    value = Exx+Exy*y
    vars = 'Exx Exy'
    vals = 'Exx Exy'
  [../]
  [./right_displacement_y]
    type = ParsedFunction
    value = Exy+Eyy*y
    vars = 'Exy Eyy'
    vals = 'Exy Eyy'
  [../]
[]

[BCs]
  [./bottom_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = bottom
    function = bot_displacement_x
    preset   = false
  [../]
  [./bottom_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = bottom
    function = bot_displacement_y
    preset   = false
  [../]
  [./left_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = left
    function = left_displacement_x
    preset   = false
  [../]
  [./left_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = left
    function = left_displacement_y
    preset   = false
  [../]
  [./top_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = top
    function = top_displacement_x
    preset   = false
  [../]
  [./top_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = top
    function = top_displacement_y
    preset   = false
  [../]
  [./right_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = right
    function = right_displacement_x
    preset   = false
  [../]
  [./right_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = right
    function = right_displacement_y
    preset   = false
  [../]
[]

[Kernels]
  [./x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
[]

[Materials]
  [./strain]
    type = ComputeIncrementalSmallStrain
  [../]
  [./elasticity_tensor_matrix]
    type = ComputeIsotropicElasticityTensor
    block = 'matrix'
    youngs_modulus = 1.0
    poissons_ratio = 0.3
  [../]
  [./stress_matrix]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'isoplas'
    block = 'matrix'
  [../]
  [./isoplas]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 0.18
    hardening_constant = 0.1
  [../]
  
  [./elasticity_tensor_fiber]
    type = ComputeIsotropicElasticityTensor
    block = 'fiber'
    youngs_modulus = 1.0
    poissons_ratio = 0.0
  [../]
  [./stress_fiber]
    type = ComputeFiniteStrainElasticStress
    block = 'fiber'
  [../]
[]


[Executioner]
  type = Transient
  solve_type = Newton

  start_time = 0.0
  dtmin = 0.0001

  end_time = 1.0
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-20
  nl_max_its = 200
  dt = 0.01

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
