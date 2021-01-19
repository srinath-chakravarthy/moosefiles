[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = asd.msh
  []
  use_displaced_mesh = false
  
  [botleft]
    type = ExtraNodesetGenerator
    coord = '0 0 0'
    new_boundary = 100
    input = mesh
  []
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
    value = 0
  [../]
  [./Fxy]
    type = ConstantFunction
    value = 0.3
  [../]
  [./Fyx]
    type = ConstantFunction
    value = 0
  [../]
  [./Fyy]
    type = ConstantFunction
    value = 0
  [../]
  [./Fxxt]
    type = ParsedFunction
    value = Fxx*t
    vars = Fxx
    vals = Fxx
  [../]
  [./Fxyt]
    type = ParsedFunction
    value = Fxy*t
    vars = Fxy
    vals = Fxy
  [../]
  [./Fyxt]
    type = ParsedFunction
    value = Fyx*t
    vars = Fyx
    vals = Fyx
  [../]
  [./Fyyt]
    type = ParsedFunction
    value = Fyy*t
    vars = Fyy
    vals = Fyy
  [../]
[]

[BCs]
  [./bottom_x]
    type = DirichletBC
    variable = 'disp_x'
    boundary = 100
    value    = 0
  [../]
  [./bottom_y]
    type = DirichletBC
    variable = 'disp_y'
    boundary = 100
    value    = 0
  [../]
[]

[Constraints]
  [topedge_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxyt
    primary  = '0 1 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288 304'
    secondary_node_ids = '927 911 895 879 863 847 831 815 799 783 767 751 735 719 703 687 671 655 639 623'
    penalty = 1e+03
  []
  [topedge_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyyt
    primary  = '0 1 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288 304'
    secondary_node_ids = '927 911 895 879 863 847 831 815 799 783 767 751 735 719 703 687 671 655 639 623'
    penalty = 1e+03
  []
  [rightedge_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxxt
    primary  = '0 1215 1199 1183 1167 1151 1135 1119 1103 1087 1071 1055 1039 1023 1007 991 975 959 943 927'
    secondary_node_ids = '304 335 351 367 383 399 415 431 447 463 479 495 511 527 543 559 575 591 607 623'
    penalty = 1e+03
  []
  [rightedge_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyxt
    primary  = '0 1215 1199 1183 1167 1151 1135 1119 1103 1087 1071 1055 1039 1023 1007 991 975 959 943 927'
    secondary_node_ids = '304 335 351 367 383 399 415 431 447 463 479 495 511 527 543 559 575 591 607 623'
    penalty = 1e+03
  []
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
    type = ComputeSmallStrain
  [../]
  [elasticity_mat]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 100
    poissons_ratio = 0.
    block = 'matrix'
  []
  [elasticity_fib]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1000
    poissons_ratio = 0.
    block = 'fiber'
  []
  [stress]
    type = ComputeLinearElasticStress
  []
[]


[Executioner]
  type = Transient
  solve_type = PJFNK
  start_time = 0.0
  dtmin = 0.0001

  end_time = 1.0
  nl_rel_tol = 1e-6
  nl_max_its = 50
  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 7
    dt = 1
  [../]

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
