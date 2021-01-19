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
  [botright_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxxt
    primary = '0'
    secondary_node_ids = '304'
    penalty = 1e+06
  []
  [botright_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyxt
    primary = '0'
    secondary_node_ids = '304'
    penalty = 1e+06
  []
  [topleft_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxyt
    primary = '0'
    secondary_node_ids = '927'
    penalty = 1e+06
  []
  [topleft_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyyt
    primary = '0'
    secondary_node_ids = '927'
    penalty = 1e+06
  []
  [topright_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxyt
    primary = '304'
    secondary_node_ids = '623'
    penalty = 1e+06
  []
  [topright_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyyt
    primary = '304'
    secondary_node_ids = '623'
    penalty = 1e+06
  []
  [topedge_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxyt
    primary  = '1 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288'
    secondary_node_ids = '911 895 879 863 847 831 815 799 783 767 751 735 719 703 687 671 655 639'
    penalty = 1e+03
  []
  [topedge_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyyt
    primary  = '1 32 48 64 80 96 112 128 144 160 176 192 208 224 240 256 272 288'
    secondary_node_ids = '911 895 879 863 847 831 815 799 783 767 751 735 719 703 687 671 655 639'
    penalty = 1e+03
  []
  [rightedge_x]
    type = EqualValuePlusConstant
    variable = disp_x
    function = Fxxt
    primary  = '1215 1199 1183 1167 1151 1135 1119 1103 1087 1071 1055 1039 1023 1007 991 975 959 943'
    secondary_node_ids = '335 351 367 383 399 415 431 447 463 479 495 511 527 543 559 575 591 607'
    penalty = 1e+03
  []
  [rightedge_y]
    type = EqualValuePlusConstant
    variable = disp_y
    function = Fyxt
    primary  = '1215 1199 1183 1167 1151 1135 1119 1103 1087 1071 1055 1039 1023 1007 991 975 959 943'
    secondary_node_ids = '335 351 367 383 399 415 431 447 463 479 495 511 527 543 559 575 591 607'
    penalty = 1e+03
  []
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
    C1 = 100
    D1 = 100
    block = 'fiber'
  [../]
[]


[Executioner]
  type = Transient
  solve_type = PJFNK
  start_time = 0.0
  dtmin = 0.0001

  end_time = 1.0
  nl_rel_tol = 1e-6
  nl_max_its = 15
  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 7
    dt = 1
  [../]

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
[]

[AuxVariables]
  [./P_xx_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xx_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xx_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xx_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xy_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xz_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xz_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xz_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_xz_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yx_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yy_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yz_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yz_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yz_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_yz_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zx_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zx_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zx_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zx_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zy_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zy_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zy_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zy_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./P_zz_4]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./P_xx_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_1
    index_i = 0
    index_j = 0
    selected_qp = 0
  [../]
  [./P_xx_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_2
    index_i = 0
    index_j = 0
    selected_qp = 1    
  [../]
  [./P_xx_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_3
    index_i = 0
    index_j = 0
    selected_qp = 2    
  [../]
  [./P_xx_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xx_4
    index_i = 0
    index_j = 0
    selected_qp = 3    
  [../]
  [./P_xy_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_1
    index_i = 0
    index_j = 1
    selected_qp = 0
  [../]
  [./P_xy_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_2
    index_i = 0
    index_j = 1
    selected_qp = 1    
  [../]
  [./P_xy_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_3
    index_i = 0
    index_j = 1
    selected_qp = 2    
  [../]
  [./P_xy_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xy_4
    index_i = 0
    index_j = 1
    selected_qp = 3    
  [../]
  [./P_xz_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xz_1
    index_i = 0
    index_j = 2
    selected_qp = 0
  [../]
  [./P_xz_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xz_2
    index_i = 0
    index_j = 2
    selected_qp = 1    
  [../]
  [./P_xz_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xz_3
    index_i = 0
    index_j = 2
    selected_qp = 2    
  [../]
  [./P_xz_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_xz_4
    index_i = 0
    index_j = 2
    selected_qp = 3    
  [../]
  [./P_yx_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_1
    index_i = 1
    index_j = 0
    selected_qp = 0
  [../]
  [./P_yx_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_2
    index_i = 1
    index_j = 0
    selected_qp = 1    
  [../]
  [./P_yx_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_3
    index_i = 1
    index_j = 0
    selected_qp = 2    
  [../]
  [./P_yx_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yx_4
    index_i = 1
    index_j = 0
    selected_qp = 3    
  [../]
  [./P_yy_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_1
    index_i = 1
    index_j = 1
    selected_qp = 0
  [../]
  [./P_yy_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_2
    index_i = 1
    index_j = 1
    selected_qp = 1    
  [../]
  [./P_yy_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_3
    index_i = 1
    index_j = 1
    selected_qp = 2    
  [../]
  [./P_yy_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yy_4
    index_i = 1
    index_j = 1
    selected_qp = 3    
  [../]
  [./P_yz_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yz_1
    index_i = 1
    index_j = 2
    selected_qp = 0
  [../]
  [./P_yz_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yz_2
    index_i = 1
    index_j = 2
    selected_qp = 1    
  [../]
  [./P_yz_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yz_3
    index_i = 1
    index_j = 2
    selected_qp = 2    
  [../]
  [./P_yz_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_yz_4
    index_i = 1
    index_j = 2
    selected_qp = 3    
  [../]
  [./P_zx_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zx_1
    index_i = 2
    index_j = 0
    selected_qp = 0
  [../]
  [./P_zx_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zx_2
    index_i = 2
    index_j = 0
    selected_qp = 1    
  [../]
  [./P_zx_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zx_3
    index_i = 2
    index_j = 0
    selected_qp = 2    
  [../]
  [./P_zx_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zx_4
    index_i = 2
    index_j = 0
    selected_qp = 3    
  [../]
  [./P_zy_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zy_1
    index_i = 2
    index_j = 1
    selected_qp = 0
  [../]
  [./P_zy_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zy_2
    index_i = 2
    index_j = 1
    selected_qp = 1    
  [../]
  [./P_zy_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zy_3
    index_i = 2
    index_j = 1
    selected_qp = 2    
  [../]
  [./P_zy_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zy_4
    index_i = 2
    index_j = 1
    selected_qp = 3    
  [../]
  [./P_zz_1]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_1
    index_i = 2
    index_j = 2
    selected_qp = 0
  [../]
  [./P_zz_2]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_2
    index_i = 2
    index_j = 2
    selected_qp = 1    
  [../]
  [./P_zz_3]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_3
    index_i = 2
    index_j = 2
    selected_qp = 2    
  [../]
  [./P_zz_4]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = P_zz_4
    index_i = 2
    index_j = 2
    selected_qp = 3    
  [../]
[]


[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  exodus = true
  print_linear_residuals = false
[]
