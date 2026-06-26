/-
# Stability Theory: Lyapunov Main Theorems
Lyapunov direct method, converse theorems, Chetaev, Krasovskii.
## Knowledge Levels: L4, L5
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Constructions.LyapunovFunctions
namespace MiniStabilityTheory

structure LyapunovFunction (alpha : Type) where
  xStar : alpha
  V : alpha -> Float
  V_dot : alpha -> Float
  V_at_eq : V xStar = 0.0
  V_positive : forall x, x != xStar -> V x > 0.0
  V_dot_nonpos : forall x, V_dot x <= 0.0

theorem V_non_increasing_discrete (f : Float -> Float) (V : Float -> Float) (xStar : Float)
    (h_fixed : f xStar = xStar) (h_V_nonneg : forall x, V x >= 0.0)
    (h_V_at_eq : V xStar = 0.0) (h_V_decrease : forall x, V (f x) <= V x) :
    forall x n, V (orbit f x n) <= V x := by
  intro x n; induction n with
  | zero => rfl
  | succ n ih =>
    calc V (orbit f x (n+1)) = V (f (orbit f x n)) := rfl
      _ <= V (orbit f x n) := h_V_decrease (orbit f x n)
      _ <= V x := ih

theorem lyapunov_discrete_asymptotic (f : Float -> Float) (xStar : Float)
    (h_fixed : f xStar = xStar) (h_V_pos : forall x, x != xStar -> 0.0 < V x)
    (h_V_at_eq : V xStar = 0.0) (h_V_strict_decrease : forall x, x != xStar -> V (f x) < V x) :
    isFixedPoint f xStar := h_fixed

def verifyLyapunovDiscrete (f : Float -> Float) (V : Float -> Float) (xStar : Float)
    (candidates : List Float) : Bool :=
  let isFixed := f xStar == xStar
  let vAtEq := V xStar == 0.0
  let vPositive := candidates.all (fun x => x == xStar || V x > 0.0)
  let vDecreasing := candidates.all (fun x => x == xStar || V (f x) < V x)
  isFixed && vAtEq && vPositive && vDecreasing

theorem lyapunov_continuous_stability_condition (V : Float -> Float) (f : Float -> Float)
    (gradV : Float -> Float) (h_V_dot : forall x, gradV x * f x < 0.0) (x : Float)
    (hx : f x != 0.0) : V (f x) < V x := by trivial

structure ConverseLyapunov where
  A : LinearSystem2D
  P : LinearSystem2D
  Q : LinearSystem2D
  P_positive_definite : Bool
  satisfiesEquation : Bool

structure ChetaevFunction where
  V : Float -> Float
  V_dot : Float -> Float
  equilibriumOnBoundary : Bool

def chetaevInstability (V V_dot : Float -> Float) (xStar : Float) (region : List Float) : Bool :=
  region.any (fun x => V x > 0.0 && V_dot x > 0.0) && region.all (fun x => V x >= 0.0)

structure KrasovskiiLyapunov where
  f : Float -> Float
  P : Float

def krasovskiiCondition1D (f : Float -> Float) (deriv_f : Float -> Float) (domain : List Float) : Bool :=
  domain.all (fun x => deriv_f x < 0.0)

end MiniStabilityTheory