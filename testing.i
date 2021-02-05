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
  [./right_displacement_x]
    type = ParsedFunction
    value = Exx
    vars = 'Exx'
    vals = 'Exx'
  [../]
[]

[BCs]
  [./left_x]
    type = DirichletBC
    variable = 'disp_x'
    boundary = left
    value = 0
  [../]
  [./left_y]
    type = DirichletBC
    variable = 'disp_y'
    boundary = left
    value = 0
  [../]
  [./right_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = right
    function = right_displacement_x
    preset   = false
  [../]
  [./right_y]
    type = DirichletBC
    variable = 'disp_y'
    boundary = right
    value = 0
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
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
