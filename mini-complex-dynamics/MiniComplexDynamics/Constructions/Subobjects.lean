/-
# MiniComplexDynamics.Constructions.Subobjects

Subsystems: invariant subsets, completely invariant sets,
subshifts, and polynomial-like maps.
-/

import MiniComplexDynamics.Core.Basic
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-- An invariant subset A satisfies f(A) subseteq A. -/
structure InvariantSubset (f : ComplexNumbers -> ComplexNumbers) where
  forwardInvariant : Bool
  backwardInvariant : Bool

/-- A completely invariant set satisfies f(A) = A = f^{-1}(A). -/
structure CompletelyInvariantSet (f : ComplexNumbers -> ComplexNumbers) where
  forwardEquality : Bool
  backwardEquality : Bool

/-- A subsystem: restriction of f to an invariant subset. -/
structure Subsystem (f : ComplexNumbers -> ComplexNumbers) where
  restrictedMap : ComplexNumbers -> ComplexNumbers
  isInvariant : Bool

/-- An exceptional set: finite completely invariant set. -/
structure ExceptionalSet (f : ComplexNumbers -> ComplexNumbers) where
  pointCount : Nat
  isFinite : Bool
  isCompletelyInvariant : Bool
  maxSize : Nat

/-- Polynomial-like map: a map f: U -> V where U, V are topological disks. -/
structure PolynomialLikeMap where
  f : ComplexNumbers -> ComplexNumbers
  isProper : Bool
  degree : Nat
  isHolomorphic : Bool

/-- A polynomial-like map is hybrid equivalent to a polynomial. -/
structure HybridEquivalence where
  quasiconformalMap : ComplexNumbers -> ComplexNumbers
  conjugacyOnJuliaSet : Bool

/-- Invariant curves. -/
structure InvariantCurve (f : ComplexNumbers -> ComplexNumbers) where
  curve : ComplexNumbers -> ComplexNumbers
  isInvariant : Bool
  isSimple : Bool

end MiniComplexDynamics
