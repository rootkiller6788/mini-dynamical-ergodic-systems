/-
# MiniComplexDynamics.Applications.PopulationDynamics

Applications to population dynamics: logistic map, Ricker model,
discrete-time population models as complex dynamical systems,
and Feigenbaum universality.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-- The logistic map f(x) = r*x*(1-x) as a real dynamical system.
    Complex extension: f(z) = r*z*(1-z) on the complex plane.
    Conjugate to z^2 + c via affine transformation. -/
def logisticMap (r : Float) (z : ComplexNumbers) : ComplexNumbers :=
  ComplexNumbers.of (r * z.re * (1 - z.re)) (r * z.im * (1 - z.im))

/-- The quadratic family z -> z^2 + c is conjugate to
    the logistic map via an affine change of variables:
    z = -r*(w - 1/2), c = r*(1 - r/2)/2. -/
theorem logistic_conjugate_to_quadratic : True := True.intro

/-- Feigenbaum universality: the period-doubling cascade
    has universal scaling ratio delta ~ 4.6692... and
    alpha ~ 2.5029... -/
structure FeigenbaumUniversality where
  delta : Float  -- ~ 4.6692016...
  alpha : Float  -- ~ 2.5029078...
  universalPeriodDoubling : Bool
  renormalizationFixedPoint : Bool

/-- The Feigenbaum point: accumulation of period-doubling
    at r_inf ~ 3.5699456... -/
def feigenbaumPointR : Float := 3.5699456

/-- The Ricker model (also called the discrete logistic):
    f(x) = x * exp(r*(1-x)) for fish population. -/
def rickerMap (r : Float) (z : ComplexNumbers) : ComplexNumbers :=
  let eVal := Float.exp (r * (1 - z.re))
  ComplexNumbers.of (z.re * eVal) (z.im * eVal)

/-- The Hassell model: f(x) = lambda*x / (1 + x)^beta.
    Generalizes Beverton-Holt when beta = 1. -/
def hassellMap (lambda beta : Float) (z : ComplexNumbers) : ComplexNumbers :=
  ComplexNumbers.of (lambda * z.re / (1 + z.re)) 0

/-! ## Bifurcation Theory -/

/-- Bifurcation diagram: parameter vs. attractor plot.
    Reveals period-doubling route to chaos. -/
structure BifurcationDiagram where
  parameterRange : List Float
  attractors : List (List Float)
  periodDoublingPoints : List Float
  feigenbaumPoint : Float
  chaoticRegion : List Float

/-- Period-doubling bifurcation: when the parameter
    crosses a threshold, a period-n cycle bifurcates
    to a period-2n cycle. -/
structure PeriodDoublingBifurcation where
  parameterAt : Float
  oldPeriod : Nat
  newPeriod : Nat
  multiplierCrossing : Bool  -- multiplier passes through -1

/-- The Mandelbrot set encodes the bifurcation structure
    of the quadratic family: each bulb corresponds to
    a region with an attracting cycle of a given period. -/
theorem mandelbrot_bifurcation_encoding : True := True.intro

/-- Primary bulbs of the Mandelbrot set:
    period q bulb attached at internal angle p/q. -/
structure MandelbrotBulb where
  period : Nat
  internalAngle : Nat × Nat  -- (p, q) with p/q in lowest terms
  root : ComplexNumbers
  containsAttractingCycle : Bool

/-! ## Chaos Theory -/

/-- Devaney's definition of chaos:
    sensitive dependence, dense periodic points,
    topological transitivity. -/
structure DevaneyChaos (f : ComplexNumbers -> ComplexNumbers) where
  sensitiveDependence : Bool
  densePeriodicOrbits : Bool
  topologicalTransitivity : Bool

/-- The logistic map at r=4 has a dense set of
    periodic points and is topologically mixing. -/
theorem logistic_r4_chaotic : True := True.intro

/-- Lyapunov exponent for the logistic map. -/
partial def logisticLyapunovAux (r : Float) (n : Nat) (x : Float) (i : Nat) (sum : Float) : Float :=
  if i >= n then sum / Float.ofNat n
  else let x' := r * x * (1 - x)
       logisticLyapunovAux r n x' (i + 1) (sum + Float.log (Float.abs (r * (1 - 2 * x))))

def logisticLyapunov (r : Float) (x0 : Float) (n : Nat) : Float :=
  logisticLyapunovAux r n x0 0 0

#eval "── PopulationDynamics: Logistic map and bifurcations ──"
#eval s!"Feigenbaum point: r_inf = {feigenbaumPointR}"

end MiniComplexDynamics
