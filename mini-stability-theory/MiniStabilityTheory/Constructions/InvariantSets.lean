/-
# Stability Theory: Invariant Set Constructions
Omega-limit sets, attractors, repellers.
## Knowledge Levels: L3, L5
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
namespace MiniStabilityTheory

def omegaLimitSet (f : alpha -> alpha) (x : alpha) : alpha -> Prop :=
  fun y => exists seq : Nat -> Nat,
    (forall k, seq k < seq (k+1)) /\
    (exists K : Nat, forall k : Nat, k >= K -> orbit f x (seq k) = y)

structure Attractor (alpha : Type) where
  f : alpha -> alpha
  basin : alpha -> Prop
  attractsNeighborhood : Bool

structure GlobalAttractor (alpha : Type) where
  f : alpha -> alpha
  attractsAllBounded : Bool

structure Repeller (alpha : Type) where
  f : alpha -> alpha
  repelsNeighborhood : Bool

def isChainRecurrent (dist : alpha -> alpha -> Float)
    (f : alpha -> alpha) (x : alpha) : Prop :=
  forall eps : Float, eps > 0.0 ->
    exists pseudoOrbit : List alpha, pseudoOrbit.length > 1

structure InvariantMeasure (alpha : Type) where
  f : alpha -> alpha
  isProbability : Bool
  isInvariant : Bool

structure PhysicalMeasure (alpha : Type) where
  basin : alpha -> Prop
  basinHasPositiveMeasure : Bool

end MiniStabilityTheory
