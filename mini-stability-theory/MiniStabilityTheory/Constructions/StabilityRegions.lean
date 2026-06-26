/-
# Stability Theory: Stability Regions
Regions of attraction, stability boundaries, parameter stability.
## Knowledge Levels: L3, L6
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
namespace MiniStabilityTheory

structure LyapunovROA where
  V : Float -> Float
  V_dot : Float -> Float
  sublevel : Float
  equilibrium : Float

def findMaxSublevel (V V_dot : Float -> Float) (grid : List Float) : Float :=
  let valid_c := grid.filterMap (fun x => if V_dot x < 0.0 then some (V x) else none)
  match valid_c.minimum? with | none => 0.0 | some c => c

structure ZubovMethod where
  phi : Float -> Float
  basinBoundary : Float

def approximateZubov (f : Float -> Float) (phi : Float -> Float) (x : Float) (steps : Nat) (dt : Float) : Float :=
  let rec integrate (y : Float) (n : Nat) (acc : Float) : Float :=
    match n with | 0 => acc | m+1 => integrate (f y) m (acc + phi y * dt)
  let integral := integrate x steps 0.0
  1.0 - Float.exp (-integral)

structure StabilityBoundary where
  equilibrium : Float
  boundaryPoints : List Float
  boundaryType : String

structure ParameterStabilityRegion where
  stableParams : List Float
  unstableParams : List Float
  boundaryParams : List Float

def partitionByStability (f : Float -> Float -> Float) (xEq : Float)
    (params : List Float) (h : Float) : ParameterStabilityRegion :=
  let stable := params.filter (fun p =>
    let J := (f p (xEq + h) - f p (xEq - h)) / (2.0*h)
    f p xEq == xEq && J.abs < 1.0)
  let unstable := params.filter (fun p =>
    let J := (f p (xEq + h) - f p (xEq - h)) / (2.0*h)
    f p xEq == xEq && J.abs > 1.0)
  let boundary := params.filter (fun p =>
    let J := (f p (xEq + h) - f p (xEq - h)) / (2.0*h)
    f p xEq == xEq && (J.abs == 1.0))
  { stableParams := stable, unstableParams := unstable, boundaryParams := boundary }

def parameterStabilityMargin (f : Float -> Float -> Float) (xEq : Float)
    (p0 : Float) (h : Float) (paramRange : Float) (numSamples : Nat) : Float :=
  let step := 2.0 * paramRange / (numSamples : Float)
  let samples := List.range numSamples |>.map (fun i => p0 - paramRange + (i : Float) * step)
  let bifurcations := samples.filter (fun p =>
    let J := (f p (xEq + h) - f p (xEq - h)) / (2.0*h)
    J.abs == 1.0)
  match bifurcations with
  | [] => paramRange
  | _ => bifurcations.map (fun p => (p - p0).abs) |>.foldl min paramRange

structure BasinPartition where
  attractors : List Float
  separatrices : List (Float -> Prop)

def whichAttractor (f : Float -> Float) (attractors : List Float)
    (x0 : Float) (steps : Nat) : Option Float :=
  let finalX := orbit f x0 steps
  attractors.find? (fun a => (finalX - a).abs < 0.001)

end MiniStabilityTheory
