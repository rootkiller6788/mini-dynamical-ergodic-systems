/-
# Stability Theory: Example Tests
#eval verification of canonical examples.
-/
import MiniStabilityTheory
open MiniStabilityTheory

def logisticStabilityAtR (r : Float) : String :=
  if r <= 0.0 then "extinct"
  else if r <= 1.0 then "zero stable"
  else if r <= 3.0 then "positive fp stable"
  else if r <= 1.0+Float.sqrt 6.0 then "period-2 stable"
  else "chaotic or periodic windows"
#eval logisticStabilityAtR 0.5; #eval logisticStabilityAtR 2.5
#eval logisticStabilityAtR 3.2; #eval logisticStabilityAtR 3.6

def vanDerPolRadius (mu x v : Float) : Float := Float.sqrt (x*x + v*v)
#eval vanDerPolRadius 1.0 0.5 0.5; #eval vanDerPolRadius 1.0 2.0 0.0

def logisticEquilibria (r K : Float) : List Float := [0.0, K]
def logisticStabilityType (r K x : Float) : String :=
  let deriv := r * (1.0 - 2.0*x/K)
  if deriv.abs < 1.0 then "stable" else "unstable"
#eval logisticStabilityType 1.0 100.0 0.0; #eval logisticStabilityType 1.0 100.0 100.0

#eval classifyByTraceDet (-3.0) 2.0; #eval classifyByTraceDet 3.0 2.0
#eval classifyByTraceDet (-1.0) 5.0; #eval classifyByTraceDet 0.0 4.0

#eval isHurwitzCubic 5.0 8.0 3.0; #eval isHurwitzCubic 1.0 1.0 1.0; #eval isHurwitzCubic 1.0 2.0 0.5

def eulerStabilityLimit (lambda dt : Float) : Bool := (1.0 - lambda * dt).abs < 1.0
def implicitEulerStabilityLimit (lambda dt : Float) : Bool := 1.0 / (1.0 + lambda * dt).abs < 1.0
#eval eulerStabilityLimit 100.0 0.01; #eval eulerStabilityLimit 100.0 0.025
#eval implicitEulerStabilityLimit 100.0 0.1

#eval "All examples complete!"
/-! ## Extended Example Tests -/

/-- Logistic map orbit generation. -/
def logisticOrbit (r x0 : Float) (n : Nat) : List Float :=
  List.range n |>.map (fun i => orbit (fun x => logisticMap r x) x0 i)

#eval logisticOrbit 2.5 0.5 5
#eval logisticOrbit 3.5 0.5 8

/-- Bifurcation detection via stability change. -/
def detectBifurcation (f : Float -> Float -> Float) (p1 p2 : Float) (xEq : Float) : Bool :=
  let f1 := fun x => f p1 x; let f2 := fun x => f p2 x
  let J1 := (f1 (xEq + 0.001) - f1 (xEq - 0.001)) / 0.002
  let J2 := (f2 (xEq + 0.001) - f2 (xEq - 0.001)) / 0.002
  (J1.abs < 1.0 && J2.abs > 1.0) || (J1.abs > 1.0 && J2.abs < 1.0)

/-- Logistic bifurcation detection. -/
def logisticFamily (r x : Float) : Float := logisticMap r x
#eval detectBifurcation logisticFamily 2.5 3.5 0.6

/-- Stable and unstable manifold approximation for 2D saddle. -/
def saddleStableDirection (A : LinearSystem2D) : Float * Float :=
  let evs := A.eigenvalues; let tr := A.trace
  if evs.length >= 2 && evs[0]! < 0.0 then (1.0, 0.0) else (0.0, 1.0)

def saddleUnstableDirection (A : LinearSystem2D) : Float * Float :=
  let evs := A.eigenvalues
  if evs.length >= 2 && evs[1]! > 0.0 then (0.0, 1.0) else (1.0, 0.0)

#eval saddleStableDirection ({ a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := -1.0 } : LinearSystem2D)
#eval saddleUnstableDirection ({ a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := -1.0 } : LinearSystem2D)

/-- Center manifold approximation. -/
def centerManifoldApprox (A : LinearSystem2D) : Float -> Float :=
  if A.det == 0.0 && A.trace < 0.0 then fun x => x*x
  else fun x => 0.0

/-- Stability of periodic orbit via Poincare map. -/
def poincareMap (f : Float -> Float -> Float) (section : Float -> Bool) (x0 : Float) : Float :=
  let rec iterate (x : Float) (n : Nat) : Float :=
    if n > 1000 then x
    else if section (f 0.0 x) then f 0.0 x
    else iterate (f 0.1 x) (n+1)
  iterate x0 0

/-- Lyapunov exponent computation for 1D map. -/
def lyapunovExponent (f : Float -> Float) (derivF : Float -> Float) (x0 : Float) (n : Nat) : Float :=
  let rec sumLogDeriv (x : Float) (k : Nat) (acc : Float) : Float :=
    match k with
    | 0 => acc
    | m+1 => sumLogDeriv (f x) m (acc + Float.log (derivF x).abs)
  let s := sumLogDeriv x0 n 0.0
  if n == 0 then 0.0 else s / (n : Float)

#eval lyapunovExponent (fun x => logisticMap 3.5 x) (fun x => logisticDeriv 3.5 x) 0.5 100
#eval lyapunovExponent (fun x => logisticMap 4.0 x) (fun x => logisticDeriv 4.0 x) 0.5 100

/-- Basin of attraction estimation via grid sampling. -/
def estimateBasin (f : Float -> Float) (attractor : Float) (gridMin gridMax : Float) (steps : Nat) (iter : Nat) : List Float :=
  let dx := (gridMax - gridMin) / (steps : Float)
  let grid := List.range steps |>.map (fun i => gridMin + (i : Float) * dx)
  grid.filter (fun x =>
    let final := orbit f x iter
    (final - attractor).abs < 0.01)

#eval estimateBasin (fun x => 0.5*x) 0.0 (-2.0) 2.0 20 20 |>.length

/-- Stability radius for a linear system. -/
def stabilityRadiusEstimate (A : LinearSystem2D) (numSamples : Nat) (maxPert : Float) : Float :=
  let samples := List.range numSamples
  let pertMags := samples.map (fun _ => maxPert * ((samples.length : Float) / (numSamples : Float)))
  match pertMags.filter (fun eps =>
    let A_pert := { a11 := A.a11 + eps, a12 := A.a12, a21 := A.a21, a22 := A.a22 + eps }
    !A_pert.isStable) |>.minimum? with
  | none => maxPert
  | some r => r

#eval stabilityRadiusEstimate testA 10 5.0

