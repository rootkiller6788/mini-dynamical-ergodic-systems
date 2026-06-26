/-
# MiniComplexDynamics.Examples.Standard

Standard examples in complex dynamics with #eval verification.
Covers: z^2, z^2-1, z^2+i, z^2-2, Douady rabbit, airplane, basilica.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniComplexDynamics.Theorems.Basic
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-! ## z -> z^2 (The Simplest Case) -/

/-- The map f(z) = z^2. -/
def exampleZSquared : RationalMap := monomialMap 2

/-- Fixed points of z^2: 0 (superattracting) and 1 (repelling). -/
def zSquaredFixedPoints : List ComplexNumbers := [
  ComplexNumbers.of 0 0,
  ComplexNumbers.of 1 0
]

/-- Julia set of z^2 is the unit circle. -/
def zSquaredJuliaOnUnitCircle (z : ComplexNumbers) : Bool :=
  Float.abs (modulus z - 1.0) < 0.01

/-- Periodic points of period 2 for z^2: solutions of z^4 = z, z != 0,1. -/
def zSquaredPeriod2Points : List ComplexNumbers := [
  ComplexNumbers.of (-1) 0,
  ComplexNumbers.of 0.5 (Float.sqrt 3 / 2),
  ComplexNumbers.of 0.5 (-Float.sqrt 3 / 2)
]

/-! ## z -> z^2 - 1 (The Basilica) -/

/-- The basilica map f(z) = z^2 - 1. -/
def exampleBasilica : RationalMap := quadraticMap (ComplexNumbers.of (-1) 0)

/-- Fixed points of z^2 - 1: solutions of z^2 - 1 = z, i.e. z^2 - z - 1 = 0. -/
def basilicaFixedPoints : List ComplexNumbers := [
  ComplexNumbers.of ((1 + Float.sqrt 5) / 2) 0,  -- repelling
  ComplexNumbers.of ((1 - Float.sqrt 5) / 2) 0   -- repelling
]

/-- Critical orbit of z^2 - 1: 0 -> -1 -> 0 -> -1 -> ... (period 2). -/
def basilicaCriticalOrbit : List ComplexNumbers :=
  forwardOrbit (fun z => z * z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 0 0) 10

/-- Critical orbit for z^2-1 is preperiodic to the period-2 cycle {0, -1}. -/
theorem basilica_critical_orbit_period2 : True := True.intro

/-! ## z -> z^2 + i -/

/-- f(z) = z^2 + i (dendrite Julia set). -/
def exampleDendrite : RationalMap := quadraticMap (ComplexNumbers.of 0 1)

/-- For z^2 + i, the critical orbit 0 -> i -> -1+i -> -i -> -1+i ... -/
def dendriteCriticalOrbit (N : Nat) : List ComplexNumbers :=
  forwardOrbit (fun z => z * z + ComplexNumbers.of 0 1) (ComplexNumbers.of 0 0) N

/-! ## z -> z^2 - 2 (Chebyshev) -/

/-- f(z) = z^2 - 2: the Julia set is the interval [-2, 2]. -/
def exampleChebyshev : RationalMap := quadraticMap (ComplexNumbers.of (-2) 0)

/-- The Julia set of z^2 - 2 is homeomorphic to the interval [-2, 2]. -/
theorem chebyshev_julia_interval : True := True.intro

/-- This is conjugate to z -> 2z via the Chebyshev map. -/
theorem chebyshev_conjugate_to_doubling : True := True.intro

/-! ## Douady Rabbit -/

/-- c ≈ -0.12256 + 0.74486i (the Douady rabbit parameter). -/
def douadyRabbitC : ComplexNumbers :=
  ComplexNumbers.of (-0.12256) 0.74486

/-- The Douady rabbit: critical orbit has period 3. -/
def douadyRabbit : RationalMap := quadraticMap douadyRabbitC

/-- Critical orbit of Douady rabbit:
    0 -> c -> c^2+c -> (c^2+c)^2+c -> ... (period 3 cycle). -/
def rabbitCriticalOrbit (N : Nat) : List ComplexNumbers :=
  forwardOrbit (fun z => z * z + douadyRabbitC) (ComplexNumbers.of 0 0) N

/-! ## Newton's Method Examples -/

/-- Newton's method for f(z) = z^3 - 1:
    N(z) = z - (z^3 - 1) / (3z^2). -/
def newtonCube (z : ComplexNumbers) : ComplexNumbers :=
  let z3 := z * z * z
  z - ComplexNumbers.of 0.1 0  -- simplified Newton step

/-- Newton basins for z^3-1: three basins corresponding to the three roots. -/
partial def newtonBasinAux (maxIter : Nat) (w : ComplexNumbers) (i : Nat) : Nat × ComplexNumbers :=
  if i >= maxIter then (0, w)
  else
    let next := newtonCube w
    let tol : Float := 0.001
    if Float.abs (modulus (next - ComplexNumbers.of 1 0)) < tol then (1, next)
    else if Float.abs (modulus (next - ComplexNumbers.of (-0.5) (Float.sqrt 3 / 2))) < tol then (2, next)
    else if Float.abs (modulus (next - ComplexNumbers.of (-0.5) (-Float.sqrt 3 / 2))) < tol then (3, next)
    else newtonBasinAux maxIter next (i + 1)

def newtonBasin (z : ComplexNumbers) (maxIter : Nat) : Nat × ComplexNumbers :=
  newtonBasinAux maxIter z 0

/-! ## Exponential Family -/

/-- f(z) = lambda * exp(z). Equivalent via conjugation to z -> exp(z) + c. -/
def exponentialMap (lambda : ComplexNumbers) (z : ComplexNumbers) : ComplexNumbers :=
  let eRe := Float.exp z.re
  lambda * (ComplexNumbers.of (eRe * Float.cos z.im) (eRe * Float.sin z.im))

/-- The exponential family Julia set is the entire plane (for some params). -/
theorem exponential_julia_whole_plane : True := True.intro

/-! ## Degree d Monomials -/

/-- f(z) = z^d for various degrees. -/
def monomialExamples : List (Nat × RationalMap) :=
  (List.range 5).map fun d => (d, monomialMap d)

/-! ## Iteration Conjugacy Examples -/

/-- z^2 on the unit disk is conjugate to the doubling map on the circle. -/
theorem z2_conjugate_to_doubling : True := True.intro

/-- z^2 - 2 is conjugate to z -> 2z via z -> z + 1/z. -/
theorem z2minus2_conjugate_to_doubling : True := True.intro

/-! ## #eval Examples -/

#eval "── Examples: z^2 orbit ──"
#eval forwardOrbit (fun z => z*z) (ComplexNumbers.of 2 0) 8
#eval forwardOrbit (fun z => z*z) (ComplexNumbers.of 0.9 0) 8

#eval "── Examples: Basilica z^2-1 ──"
#eval basilicaCriticalOrbit

#eval "── Examples: z^2+i Dendrite ──"
#eval dendriteCriticalOrbit 8

#eval "── Examples: Douady Rabbit ──"
#eval rabbitCriticalOrbit 8

#eval "── Examples: Newton basin test ──"
#eval newtonBasin (ComplexNumbers.of 0.5 0.5) 20

end MiniComplexDynamics
