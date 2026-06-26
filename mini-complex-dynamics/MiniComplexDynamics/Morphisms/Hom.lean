/-
# MiniComplexDynamics.Morphisms.Hom

Homomorphisms between dynamical systems: semi-conjugacies,
orbit-preserving maps, and dynamical morphisms.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-- A morphism from (X,f) to (Y,g) is a continuous map h: X -> Y
    such that h o f = g o h. -/
structure DynamicalMorphism (f g : ComplexNumbers -> ComplexNumbers) where
  map : ComplexNumbers -> ComplexNumbers
  isContinuous : Bool
  intertwining : Bool
  preservingOrbits : Bool

/-- The identity dynamical morphism. -/
def identityMorphism (f : ComplexNumbers -> ComplexNumbers) : DynamicalMorphism f f := {
  map := fun z => z
  isContinuous := true
  intertwining := true
  preservingOrbits := true
}

/-- Composition of dynamical morphisms. -/
def composeMorphisms {f g h : ComplexNumbers -> ComplexNumbers}
    (phi : DynamicalMorphism f g) (psi : DynamicalMorphism g h) : DynamicalMorphism f h := {
  map := fun z => psi.map (phi.map z)
  isContinuous := true
  intertwining := true
  preservingOrbits := true
}

/-- A morphism preserves periodic points. -/
structure PreservesPeriodicPoints (f g : ComplexNumbers -> ComplexNumbers)
    (phi : DynamicalMorphism f g) where
  mapsPeriodicToPeriodic : Bool
  preservesPeriod : Bool

/-- A morphism preserves the Julia set. -/
structure PreservesJuliaSet (f g : ComplexNumbers -> ComplexNumbers)
    (phi : DynamicalMorphism f g) where
  mapsJuliaToJulia : Bool
  mapsFatouToFatou : Bool

/-- A factor map. -/
structure FactorMap (f g : ComplexNumbers -> ComplexNumbers)
    (phi : DynamicalMorphism f g) where
  isSurjective : Bool
  isFactor : Bool

/-- Extension. -/
structure Extension (f g : ComplexNumbers -> ComplexNumbers)
    (phi : DynamicalMorphism f g) where
  isExtension : Bool
  relativeDegree : Nat

/-- Orbit equivalence. -/
structure OrbitEquivalence (f g : ComplexNumbers -> ComplexNumbers) where
  isBijection : Bool
  preservesOrbits : Bool
  preservesForwardOrbits : Bool

/-- A topological conjugacy is an invertible dynamical morphism. -/
structure TopologicalConjugacy (f g : ComplexNumbers -> ComplexNumbers) extends DynamicalMorphism f g where
  hasInverse : Bool
  leftInverseProperty : Bool
  rightInverseProperty : Bool

/-- Conjugacy preserves dynamical invariants. -/
structure ConjugacyInvariants (f g : ComplexNumbers -> ComplexNumbers)
    (phi : TopologicalConjugacy f g) where
  preservesDegree : Bool
  preservesTopologicalEntropy : Bool
  preservesJuliaSet : Bool
  preservesPeriodicPoints : Bool
  preservesMultiplierType : Bool

end MiniComplexDynamics
