//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADComputeHyper.h"

registerMooseObject("TheronApp", ADComputeHyper);

InputParameters
ADComputeHyper::validParams()
{
  InputParameters params = ADComputeStressBase::validParams();
  params.addClassDescription("Compute stress using elasticity for finite strains");
  params.addRequiredParam<Real>("C1", "First parameter of Neo-Hookean.");
  params.addRequiredParam<Real>("D1", "Second parameter of Neo-Hookean.");
  return params;
}

ADComputeHyper::ADComputeHyper(
    const InputParameters & parameters)
  : ADComputeStressBase(parameters),
    GuaranteeConsumer(this),
    _deformation_gradient(getADMaterialPropertyByName<RankTwoTensor>(_base_name + "deformation_gradient")),
    _cauchy_stress(declareADProperty<RankTwoTensor>(_base_name + "cauchy_stress")),
    _C1(parameters.isParamValid("C1") ? this->template getParam<Real>("C1") : -1),
    _D1(parameters.isParamValid("D1") ? this->template getParam<Real>("D1") : -1)
{
}

void
ADComputeHyper::computeQpStress()
{
  ADRankTwoTensor iden(ADRankTwoTensor::initIdentity);
  ADRankTwoTensor right_cg = _deformation_gradient[_qp].transpose() * _deformation_gradient[_qp];
  ADRankTwoTensor right_cg_inv = right_cg.inverse();
  _stress[_qp] = 2.0*(_C1*(iden - right_cg_inv) + _D1*(_deformation_gradient[_qp].det()-1.0)*_deformation_gradient[_qp].det()*right_cg_inv);
  _stress[_qp] = _deformation_gradient[_qp]*_stress[_qp];
  _cauchy_stress[_qp] = _stress[_qp]*_deformation_gradient[_qp].transpose()/_deformation_gradient[_qp].det();
}
