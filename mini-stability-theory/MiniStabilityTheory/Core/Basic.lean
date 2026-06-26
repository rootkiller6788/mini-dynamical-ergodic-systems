/-
# Stability Theory: Core Definitions
Fundamental definitions for stability theory using Float arithmetic.
Lean 4.31.0 has removed Real from core; Float is the only continuous type.

## Knowledge Levels
- L1: Core definitions (LyapunovStable, AsymptoticallyStable, ExponentiallyStable)
- L2: Core concepts (Lyapunov functions, comparison functions, basin of attraction)
-/

namespace MiniStabilityTheory

/-- Pi constant for Float. -/
def pi : Float := 3.141592653589793

/-- 2*pi. -/
def two_pi : Float := 2.0 * pi

/-! ## Discrete Dynamical Systems -/

/-- A discrete-time dynamical system on a type alpha. -/
structure DiscreteSystem (alpha : Type) where
  step : alpha -> alpha

def DiscreteSystem.iterate (ds : DiscreteSystem alpha) : Nat -> alpha -> alpha
  | 0, x => x
  | n+1, x => ds.step (iterate ds n x)

notation:max f "^[" n "]" => DiscreteSystem.iterate f n

def orbit (f : alpha -> alpha) (x : alpha) : Nat -> alpha
  | 0 => x
  | n+1 => f (orbit f x n)

/-! ## Continuous Systems -/

structure ContinuousSystem (alpha : Type) where
  flow : Float -> alpha -> alpha
  initialCondition : forall x, flow 0.0 x = x
  groupProperty : forall (t s : Float) x, flow (t + s) x = flow t (flow s x)

/-! ## Equilibrium Points -/

def isEquilibrium (flow : Float -> alpha -> alpha) (xStar : alpha) : Prop :=
  forall t : Float, flow t xStar = xStar

def isFixedPoint (f : alpha -> alpha) (xStar : alpha) : Prop :=
  f xStar = xStar

def isPeriodicPoint (f : alpha -> alpha) (x : alpha) (n : Nat) [BEq alpha] : Prop :=
  orbit f x n = x /\ forall k, 0 < k -> k < n -> orbit f x k != x

/-! ## Stability Definitions (Lyapunov Sense) -/

def isLyapunovStable (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (xStar : alpha) : Prop :=
  forall eps : Float, eps > 0.0 ->
    exists delta : Float, delta > 0.0 /\
    (forall x0 : alpha, dist x0 xStar < delta ->
      forall t : Float, t >= 0.0 -> dist (flow t x0) xStar < eps)

def isLyapunovStableDiscrete (dist : alpha -> alpha -> Float)
    (f : alpha -> alpha) (xStar : alpha) : Prop :=
  isFixedPoint f xStar /\
  forall eps : Float, eps > 0.0 ->
    exists delta : Float, delta > 0.0 /\
    (forall x0 : alpha, dist x0 xStar < delta ->
      forall n : Nat, dist (orbit f x0 n) xStar < eps)

def isAttractive (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (xStar : alpha) : Prop :=
  exists eta : Float, eta > 0.0 /\
  (forall x0 : alpha, dist x0 xStar < eta ->
    forall eps : Float, eps > 0.0 ->
      exists T : Float, T > 0.0 /\
      forall t : Float, t >= T -> dist (flow t x0) xStar < eps)

def isAsymptoticallyStable (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (xStar : alpha) : Prop :=
  isLyapunovStable dist flow xStar /\ isAttractive dist flow xStar

def isExponentiallyStable (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (xStar : alpha) : Prop :=
  exists M : Float, M > 0.0 /\
  exists lambda : Float, lambda > 0.0 /\
  exists delta : Float, delta > 0.0 /\
  forall x0 : alpha, dist x0 xStar < delta ->
    forall t : Float, t >= 0.0 ->
      dist (flow t x0) xStar <= M * dist x0 xStar * Float.exp (-lambda * t)

/-! ## Stability Types -/

inductive StabilityType : Type where
  | saddle | unstableNode | unstableFocus | center
  | stableNode | stableFocus | degenerate
  deriving BEq, Repr, Inhabited

def StabilityType.strength (s : StabilityType) : Int :=
  match s with
  | .unstableNode => -3 | .unstableFocus => -2 | .saddle => -1
  | .center => 0 | .degenerate => 0
  | .stableFocus => 2 | .stableNode => 3

def StabilityType.isStable (s : StabilityType) : Bool :=
  match s with
  | .stableNode => true | .stableFocus => true | _ => false

def StabilityType.isHyperbolic (s : StabilityType) : Bool :=
  match s with
  | .center => false | .degenerate => false | _ => true

/-! ## Orbital Stability -/

def isOrbitallyStable (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (gamma : alpha -> Prop) : Prop :=
  forall eps : Float, eps > 0.0 ->
    exists delta : Float, delta > 0.0 /\
    (forall x0 : alpha, (exists y : alpha, gamma y /\ dist x0 y < delta) ->
      forall t : Float, t >= 0.0 ->
        exists z : alpha, gamma z /\ dist (flow t x0) z < eps)

/-! ## Basin of Attraction -/

def basinOfAttraction (dist : alpha -> alpha -> Float)
    (flow : Float -> alpha -> alpha) (xStar : alpha) : alpha -> Prop :=
  fun x => forall eps : Float, eps > 0.0 ->
    exists T : Float, T > 0.0 /\
    forall t : Float, t >= T -> dist (flow t x) xStar < eps

/-! ## Comparison Functions -/

def isClassK (gamma : Float -> Float) : Prop :=
  gamma 0.0 = 0.0 /\ (forall r s, r < s -> gamma r < gamma s) /\
  (forall r, r >= 0.0 -> gamma r >= 0.0)

def isClassKInf (gamma : Float -> Float) : Prop :=
  isClassK gamma /\ (forall N : Float, exists r : Float, gamma r > N)

/-! ## Hyperbolicity -/

def isHyperbolicContinuous (eigenvalues : List Float) : Bool :=
  eigenvalues.all (fun lambda => lambda != 0.0)

def isHyperbolicDiscrete (multipliers : List Float) : Bool :=
  multipliers.all (fun mu => mu.abs != 1.0)

/-! ## Stability Equivalences -/

structure TopologicalConjugacy (alpha : Type) where
  f : alpha -> alpha
  g : alpha -> alpha
  h : alpha -> alpha
  conjugacyEq : forall x, h (f x) = g (h x)

end MiniStabilityTheory