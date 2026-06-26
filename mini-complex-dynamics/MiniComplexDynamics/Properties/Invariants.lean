/-
# MiniComplexDynamics.Properties.Invariants

Dynamical invariants: topological entropy, Lyapunov exponents,
Green's function, harmonic measure, and ergodic properties.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-! ## Topological Entropy -/

/-- The topological entropy h_top(f) = log(deg(f)). -/
def topologicalEntropyInvariant (f : RationalMap) : Float :=
  Float.log (Float.ofNat f.degree)

/-- Entropy is a conjugacy invariant. -/
structure EntropyConjugacyInvariant where
  entropyPreserved : Bool  -- h_top(phi o f o phi^{-1}) = h_top(f)

/-- Entropy is additive under iteration: h_top(f^n) = n * h_top(f). -/
structure EntropyAdditiveUnderIteration (f : RationalMap) where
  entropyIterationLaw : Bool

/-! ## Lyapunov Exponents -/

/-- The Lyapunov exponent of a point z measures exponential
    rate of divergence of nearby orbits. -/
structure LyapunovExponent (f : ComplexNumbers -> ComplexNumbers) (z : ComplexNumbers) where
  value : Float
  lyapExists : Bool  -- limit of (1/n) * log|(f^n)'(z)|
  measureTheoretic : Bool

/-- For a rational map of degree d, the Lyapunov exponent
    exists for almost every z (with respect to maximal entropy measure). -/
structure LyapunovAlmostEverywhere (f : RationalMap) where
  existsForAlmostAll : Bool
  equalsLogDegree : Bool  -- chi(z) = log d for almost every z

/-! ## Green's Function -/

/-- The Green's function of the Julia set (for polynomials). -/
structure GreensFunction (f : ComplexNumbers -> ComplexNumbers) where
  g : ComplexNumbers -> Float
  escapeRate : Bool
  harmonicOutsideJulia : Bool
  zeroOnFilledJulia : Bool

/-- The dynamical Green's function for degree d polynomial. -/
partial def greensAux (f : ComplexNumbers -> ComplexNumbers) (d : Nat) (maxIter : Nat) (w : ComplexNumbers) (n : Nat) (sum : Float) : Float :=
  if n >= maxIter then sum
  else greensAux f d maxIter (f w) (n+1) (sum + Float.log ((if modulus w > 1 then modulus w else 1)) / (Float.ofNat d) ^ Float.ofNat n)

def dynamicalGreensFunction (f : ComplexNumbers -> ComplexNumbers) (d : Nat) (z : ComplexNumbers) (maxIter : Nat) : Float :=
  greensAux f d maxIter z 0 0

/-! ## Harmonic Measure -/

/-- The harmonic measure on the Julia set. -/
structure HarmonicMeasure (f : ComplexNumbers -> ComplexNumbers) where
  measure : (ComplexNumbers -> Bool) -> Float
  support : ComplexNumbers -> Bool
  equalsJuliaSet : Bool
  uniqueMaxEntropy : Bool

/-! ## Measure of Maximal Entropy -/

/-- Brolin-Lyubich measure: the unique measure of maximal entropy. -/
structure MaximalEntropyMeasure (f : RationalMap) where
  measure : (ComplexNumbers -> Bool) -> Float
  entropy : Float
  uniqueness : Bool
  balancedProperty : Bool  -- f*mu = d * mu

/-- The balanced measure property: f*mu = d * mu where d = deg(f). -/
structure BalancedMeasure (f : RationalMap) where
  mu : (ComplexNumbers -> Bool) -> Float
  pullback : Bool  -- f*mu(A) = mu(f^{-1}(A))
  pushforward : Bool  -- f_*mu = d * mu
  entropyMaximizing : Bool

/-! ## Ergodic Invariants -/

/-- Ergodicity: every invariant measurable set has measure 0 or 1. -/
structure Ergodic (f : ComplexNumbers -> ComplexNumbers) (mu : (ComplexNumbers -> Bool) -> Float) where
  invariantSetsMeasureZeroOrOne : Bool
  equivalentConditions : Bool

/-- Mixing: correlations decay to zero. -/
structure Mixing (f : ComplexNumbers -> ComplexNumbers) (mu : (ComplexNumbers -> Bool) -> Float) where
  decayOfCorrelations : Bool
  impliesErgodic : Bool

/-- Exactness: intersection of forward images is trivial. -/
structure ExactEndomorphism (f : ComplexNumbers -> ComplexNumbers) where
  tailTrivial : Bool

/-! ## #eval -/

#eval "── Invariants: Topological entropy ──"
#eval topologicalEntropyInvariant (quadraticMap (ComplexNumbers.of (-1) 0))

#eval "── Invariants: Green's function approximation ──"
#eval dynamicalGreensFunction (fun z => z*z) 2 (ComplexNumbers.of 1 0) 10

end MiniComplexDynamics
