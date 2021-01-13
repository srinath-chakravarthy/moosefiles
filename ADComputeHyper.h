//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADComputeStressBase.h"
#include "GuaranteeConsumer.h"

/**
 * ADComputeHyper computes the stress following elasticity
 * theory for finite strains
 */
class ADComputeHyper : public ADComputeStressBase, public GuaranteeConsumer
{
public:
  static InputParameters validParams();

  ADComputeHyper(const InputParameters & parameters);

protected:
  virtual void computeQpStress() override;

  ADReal _C1;
  ADReal _D1;

  const ADMaterialProperty<RankTwoTensor> & _deformation_gradient;
  ADMaterialProperty<RankTwoTensor> & _cauchy_stress;
};
