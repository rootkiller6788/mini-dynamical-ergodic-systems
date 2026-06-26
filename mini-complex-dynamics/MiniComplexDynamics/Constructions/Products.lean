/-
# MiniComplexDynamics.Constructions.Products

Product dynamical systems: direct products, skew products,
and fibered dynamical systems.
-/

import MiniComplexDynamics.Core.Basic
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-- Direct product of two dynamical systems. -/
structure ProductSystem (f g : ComplexNumbers -> ComplexNumbers) where
  productMap : ComplexNumbers -> ComplexNumbers -> ComplexNumbers × ComplexNumbers
  componentMaps : ComplexNumbers -> ComplexNumbers × (ComplexNumbers -> ComplexNumbers)
  isProduct : Prop

/-- Skew product dynamics: F(x,y) = (f(x), g_x(y)). -/
structure SkewProduct (f : ComplexNumbers -> ComplexNumbers)
    (g : ComplexNumbers -> ComplexNumbers -> ComplexNumbers) where
  baseMap : ComplexNumbers -> ComplexNumbers
  fiberMap : ComplexNumbers -> ComplexNumbers -> ComplexNumbers
  skewEquation : Prop

/-- Fibered Julia set: Julia set of a fibered system. -/
structure FiberedJuliaSet (f : ComplexNumbers -> ComplexNumbers)
    (g : ComplexNumbers -> ComplexNumbers -> ComplexNumbers) where
  totalJuliaSet : ComplexNumbers × ComplexNumbers -> Bool
  baseJuliaSet : ComplexNumbers -> Bool
  fiberJuliaSets : ComplexNumbers -> (ComplexNumbers -> Bool)
  fiberedProperties : Prop

/-- Tensor product of iteration operators. -/
def iterationTensorProduct (f g : ComplexNumbers -> ComplexNumbers) (m n : Nat) (z w : ComplexNumbers) : ComplexNumbers × ComplexNumbers :=
  (iterate f m z, iterate g n w)

/-- Product of rational maps. -/
def productRationalMap (R S : RationalMap) : RationalMap := {
  numeratorDegree := R.numeratorDegree + S.numeratorDegree
  denominatorDegree := R.denominatorDegree + S.denominatorDegree
  degree := R.degree * S.degree
  eval := fun _ => ComplexNumbers.of 0 0
  isRational := true
  hasPoles := R.hasPoles || S.hasPoles
  criticalPoints := R.criticalPoints ++ S.criticalPoints
}

#eval "── Products: Direct product systems ──"
#eval iterationTensorProduct (fun z => z*z) (fun z => z*z) 3 2 (ComplexNumbers.of 2 0) (ComplexNumbers.of 1 0)

end MiniComplexDynamics
