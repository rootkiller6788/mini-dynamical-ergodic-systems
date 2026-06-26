/-
# MiniComplexDynamics.Advanced.Renormalization

Advanced topic: Renormalization in complex dynamics.
Douady-Hubbard renormalization, McMullen's tower, and renormalization horseshoe.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Advanced.ParabolicImplosion
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics

namespace MiniComplexDynamics

/-- A quadratic-like map is renormalizable if some iterate
    restricts to a quadratic-like map with connected Julia set. -/
structure Renormalizable where
  original : ComplexNumbers -> ComplexNumbers
  period : Nat
  smallJuliaSet : ComplexNumbers -> Bool
  renormalizedMap : ComplexNumbers -> ComplexNumbers
  hybridEquivalentTo : ComplexNumbers

/-- Simple renormalization: the small Julia set is homeomorphic
    to the Julia set of a (usually different) quadratic polynomial. -/
structure SimpleRenormalization where
  criticalOrbitPeriod : Nat
  renormalizationPeriod : Nat
  internalClass : ComplexNumbers  -- c value for the renormalized map

/-- Crossed renormalization: two small Julia sets intersect. -/
structure CrossedRenormalization where
  period1 : Nat
  period2 : Nat
  intersection : ComplexNumbers -> Bool
  intersectingJuliaSets : Prop

/-- Primitive renormalization: small Julia set has trivial
    fundamental group complement. -/
structure PrimitiveRenormalization where
  isPrimitive : Prop
  noSatellite : Prop

/-- Satellite renormalization: small Julia set attached at a
    parabolic point of the renormalized dynamics. -/
structure SatelliteRenormalization where
  attachingPoint : ComplexNumbers
  isParabolic : Prop
  tuning : ComplexNumbers

/-- McMullen's tower: infinite sequence of renormalizations
    giving a geometric limit. -/
structure McMullensTower where
  levels : Nat -> (ComplexNumbers -> ComplexNumbers)
  geometricLimit : ComplexNumbers -> ComplexNumbers
  accumulationOfRenormalization : Prop

/-- Renormalization horseshoe: the renormalization operator
    has a horseshoe-type dynamics on parameter space. -/
structure RenormalizationHorseshoe where
  operator : (ComplexNumbers -> ComplexNumbers) -> (ComplexNumbers -> ComplexNumbers)
  fixedPoints : List (ComplexNumbers -> ComplexNumbers)
  unstableManifolds : Prop
  stableManifolds : Prop

/-- Infinitely renormalizable maps: the "deep" parameters. -/
structure InfinitelyRenormalizable where
  infiniteSequence : Nat -> (ComplexNumbers -> ComplexNumbers)
  convergenceToLimit : Prop
  limitMap : ComplexNumbers -> ComplexNumbers

#eval "── Renormalization: DH renormalization, McMullen tower ──"

end MiniComplexDynamics
