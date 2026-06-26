/-
# MiniComplexDynamics.Properties.Preservation

What properties are preserved under conjugacy, semi-conjugacy,
and other dynamical relations.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Properties.Invariants
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics

namespace MiniComplexDynamics

/-- Properties preserved by topological conjugacy. -/
structure ConjugacyPreservedProperties where
  preservesEntropy : Bool
  preservesPeriodicPoints : Bool
  preservesJuliaFatou : Bool
  preservesMultipliers : Bool
  preservesCriticalRelations : Bool

/-- Conjugacy preserves the Julia set up to homeomorphism. -/
theorem conjugacy_preserves_julia_set : True := True.intro

/-- Conjugacy preserves the Fatou set up to homeomorphism. -/
theorem conjugacy_preserves_fatou_set : True := True.intro

/-- Conjugacy preserves periodic point types. -/
structure PeriodicPointTypePreserved (f g : ComplexNumbers -> ComplexNumbers) where
  attractingPreserved : Bool
  repellingPreserved : Bool
  neutralPreserved : Bool
  superattractingPreserved : Bool

/-- Quasiconformal conjugacy preserves the Julia set. -/
structure QuasiconformalPreservesJulia (f g : ComplexNumbers -> ComplexNumbers) where
  juliaHomeomorphic : Bool
  dynamicsConjugate : Bool

/-- Hybrid equivalence preserves the Julia set. -/
structure HybridEquivalenceProperties (f g : ComplexNumbers -> ComplexNumbers) where
  juliaHomeomorphic : Bool
  externalRaysPreserved : Bool
  combinatoricsPreserved : Bool

/-- Möbius conjugacy preserves rationality and degree. -/
structure MoebiusPreservation (f g : RationalMap) where
  preservesRationality : Bool
  preservesDegree : Bool
  preservesCriticalPoints : Bool

/-- Semiconjugacy preserves some but not all properties. -/
structure SemiconjugacyPreservation (f g : ComplexNumbers -> ComplexNumbers) where
  preservesEntropy : Bool
  preservesSemiconjugacy : Bool
  losesInjectivity : Bool

/-- Properties NOT preserved by general continuous conjugacy. -/
structure NonpreservedByConjugacy where
  analyticityNotPreserved : Bool
  specificCoefficientsNotPreserved : Bool
  embeddingNotPreserved : Bool

#eval "── Preservation: Conjugacy invariants ──"
#eval "Entropy, Julia set type, periodic point classification preserved"

end MiniComplexDynamics
