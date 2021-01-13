[Mesh]
  file = asd.msh
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
  [./Fxx]
    type = ConstantFunction
    value = -0.3
  [../]
  [./Fxy]
    type = ConstantFunction
    value = -0.#3
  [../]
  [./Fyx]
    type = ConstantFunction
    value = -0.#3
  [../]
  [./Fyy]
    type = ConstantFunction
    value = -0.#3
  [../]
  [./bot_displacement_x]
    type = ParsedFunction
    value = Fxx*t*x
    vars = Fxx
    vals = Fxx
  [../]
  [./bot_displacement_y]
    type = ParsedFunction
    value = Fyx*t*x
    vars = Fyx
    vals = Fyx
  [../]
  [./left_displacement_x]
    type = ParsedFunction
    value = Fxy*t*y
    vars = Fxy
    vals = Fxy
  [../]
  [./left_displacement_y]
    type = ParsedFunction
    value = Fyy*t*y
    vars = Fyy
    vals = Fyy
  [../]
  [./top_displacement_x]
    type = ParsedFunction
    value = Fxx*t*x+Fxy*t
    vars = 'Fxx Fxy'
    vals = 'Fxx Fxy'
  [../]
  [./top_displacement_y]
    type = ParsedFunction
    value = Fyx*t*x+Fyy*t
    vars = 'Fyx Fyy'
    vals = 'Fyx Fyy'
  [../]
  [./right_displacement_x]
    type = ParsedFunction
    value = Fxx*t+Fxy*t*y
    vars = 'Fxx Fxy'
    vals = 'Fxx Fxy'
  [../]
  [./right_displacement_y]
    type = ParsedFunction
    value = Fyx*t+Fyy*t*y
    vars = 'Fyx Fyy'
    vals = 'Fyx Fyy'
  [../]
[]

[BCs]
  [./left_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = left
    function = left_displacement_x
  [../]
  [./left_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = left
    function = left_displacement_y
  [../]
  [./right_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = right
    function = right_displacement_x
  [../]
  [./right_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = right
    function = right_displacement_y
  [../]
  [./bot_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = bottom
    function = bot_displacement_x
  [../]
  [./bot_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = bottom
    function = bot_displacement_y
  [../]
  [./top_x]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = top
    function = top_displacement_x
  [../]
  [./top_y]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = top
    function = top_displacement_y
  [../]
[]

[Kernels]
  [./x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
[]

[Materials]
  [./strain]
    type = ADComputeDeformationGradient
  [../]
  [./stress_mat]
    type = ADComputeHyper
    C1 = 1.0
    D1 = 1.0
    block = 'matrix'
  [../]
  [./stress_fib]
    type = ADComputeHyper
    C1 = 100.0
    D1 = 100.0
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
  nl_max_its = 30
  dt = 0.5
  
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
  
  [./Quadrature]
    order = second
  []
[]

[AuxVariables]
  [./stress_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_z]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_x]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_x
    index_i = 0
    index_j = 0
  [../]
  [./stress_y]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_y
    index_i = 1
    index_j = 1
  [../]
  [./stress_z]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_z
    index_i = 2
    index_j = 2
  [../]
  [./stress_xy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yz]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
