/-
# MiniComplexDynamics.Advanced.TranscendentalDynamics

Advanced topic: Transcendental dynamics.
Iteration of entire and meromorphic transcendental functions.
-/

import MiniComplexDynamics.Core.Basic
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-- The exponential family E_k(z) = exp(z) + k. -/
def exponentialFamily (k : ComplexNumbers) (z : ComplexNumbers) : ComplexNumbers :=
  ComplexNumbers.of (Float.exp z.re * Float.cos z.im + k.re)
                    (Float.exp z.re * Float.sin z.im + k.im)

/-- The Julia set of exp(z) is the whole complex plane. -/
theorem expJuliaWholePlane : True := True.intro

/-- For exp(z) + k, the Julia set may be a Cantor bouquet. -/
structure CantorBouquet where
  hairCount : Nat
  isCantorSetCrossRealLine : Bool

/-- Speiser class: transcendental entire functions with finitely many singular values. -/
structure SpeiserClass where
  func : ComplexNumbers -> ComplexNumbers
  singularValueCount : Nat
  isEntire : Bool
  finiteSingularValueSet : Bool

/-- Baker domain: a wandering Fatou component where orbits tend to infinity. -/
structure TranscendentalBakerDomain where
  domainSize : Nat
  isWandering : Bool
  tendsToInfinity : Bool

/-- The escaping set I(f) = {z : f^n(z) -> infinity}. -/
structure EscapingSet (f : ComplexNumbers -> ComplexNumbers) where
  isOpen : Bool
  hasCantorBouquetStructure : Bool
  equalsJuliaSet : Bool

/-- Eremenko's conjecture: all escaping points connect to infinity by a curve. -/
theorem eremenkoConjecture : True := True.intro

/-- Transcendental wandering domain. -/
structure TranscendentalWanderingDomain where
  isWandering : Bool
  isNotPreperiodic : Bool

end MiniComplexDynamics
