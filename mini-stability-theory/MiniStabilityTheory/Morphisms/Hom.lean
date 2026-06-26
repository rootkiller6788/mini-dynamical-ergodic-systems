/-
# Stability Theory: Stability-Preserving Morphisms
## Knowledge Levels: L3
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
namespace MiniStabilityTheory

/-- A stability-preserving map between discrete systems. -/
structure StabilityMorphism (alpha beta : Type) where
  source : alpha -> alpha
  target : beta -> beta
  phi : alpha -> beta
  semiconjugacy : forall x, phi (source x) = target (phi x)

/-- Contractive map: dist(f(x), f(y)) <= c * dist(x, y) with c < 1. -/
def isContraction (dist : alpha -> alpha -> Float) (f : alpha -> alpha) (c : Float) : Prop :=
  0.0 <= c /\ c < 1.0 /\
  forall x y : alpha, dist (f x) (f y) <= c * dist x y

/-- Stability partial order. -/
def stabilityPartialOrder (s1 s2 : StabilityType) : Bool :=
  StabilityType.strength s1 >= StabilityType.strength s2

/-- Input-output system. -/
structure IOSystem (alpha beta : Type) where
  initialState : alpha
  transition : alpha -> beta -> alpha
  output : alpha -> beta

/-- Finite-gain stability. -/
structure FiniteGainStable (alpha beta : Type) where
  system : IOSystem alpha beta
  gain : Float
  bias : Float

/-- Small-gain theorem structure. -/
structure SmallGainTheorem where
  gain1 : Float
  gain2 : Float
  isStable : gain1 * gain2 < 1.0

/-- Cascade system. -/
structure CascadeSystem where
  f : Float -> Float
  g : Float -> Float -> Float
  xStable : Bool
  yConditionallyStable : Bool

end MiniStabilityTheory