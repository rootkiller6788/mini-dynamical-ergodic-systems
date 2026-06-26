import os

BASE = r"F:\nano-everything\mini-everything-math\18. mini-dynamical-ergodic-systems\mini-random-dynamical-systems\MiniRandomDynamicalSystems"

def wf(relpath, content):
    full = os.path.join(BASE, relpath)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Wrote {relpath}: {len(content.splitlines())} lines")

wf("Core/Laws.lean", """\
/-
# MiniRandomDynamicalSystems: Core Laws -- L2-L5
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic

namespace MiniRandomDynamicalSystems

variable {Omega X : Type} {ns : NoiseSpace Omega}
variable (c : Cocycle Omega X ns)

/-! Cocycle identities -/

theorem cocycle_zero_identity (omega : Omega) (x : X) : c.phi 0 omega x = x :=
  c.initial_condition omega x

theorem cocycle_one_identity (omega : Omega) (x : X) : c.phi 1 omega x = c.oneStep omega x := rfl

theorem cocycle_compose_at_time (n k : Nat) (omega : Omega) (x : X) :
    c.phi n (ns.iterate k omega) (c.phi k omega x) = c.phi (n + k) omega x := by
  rw [add_comm, c.cocycle_property n k omega x]

theorem cocycle_succ_decompose (n : Nat) (omega : Omega) (x : X) :
    c.phi (n+1) omega x = c.phi n (ns.theta omega) (c.oneStep omega x) := by
  calc
    c.phi (n+1) omega x = c.phi n (ns.iterate 1 omega) (c.phi 1 omega x) := by
      simpa [add_comm] using c.cocycle_property n 1 omega x
    _ = c.phi n (ns.theta omega) (c.oneStep omega x) := by simp [NoiseSpace.iterate, Cocycle.oneStep]

theorem cocycle_two_step (n : Nat) (omega : Omega) (x : X) :
    c.phi (n+2) omega x =
    c.phi n (ns.theta (ns.theta omega)) (c.oneStep (ns.theta omega) (c.oneStep omega x)) := by
  rw [cocycle_succ_decompose c (n+1) omega x]
  rw [cocycle_succ_decompose c n (ns.theta omega) (c.oneStep omega x)]
  rfl

theorem cocycle_as_composition (n : Nat) (omega : Omega) (x : X) :
    c.phi n omega x =
    (Nat.recOn n (fun _ => x)
      (fun m ih w => c.oneStep (ns.iterate m w) (ih w))) omega := by
  induction n generalizing omega x with
  | zero => rfl
  | succ n ih =>
    simp [Nat.recOn]
    rw [cocycle_succ_decompose c n omega x]
    rw [ih (ns.theta omega) (c.oneStep omega x)]
    simp [NoiseSpace.iterate]

/-! Additive cocycle identities -/

variable (f : Omega -> Int)

theorem additive_one_step (omega : Omega) (x : Int) :
    (additiveCocycle f).phi 1 omega x = x + f omega := by
  simp [additiveCocycle, Cocycle.oneStep]

theorem additive_succ_recurrence (n : Nat) (omega : Omega) (x : Int) :
    (additiveCocycle f).phi (n+1) omega x =
    (additiveCocycle f).phi n (ns.theta omega) (x + f omega) := by
  simp [additiveCocycle, NoiseSpace.iterate]

theorem additive_translation (n : Nat) (omega : Omega) (x y : Int) :
    (additiveCocycle f).phi n omega (x + y) =
    (additiveCocycle f).phi n omega x + y := by
  induction n generalizing omega x y with
  | zero => rfl
  | succ n ih =>
    simp [additiveCocycle]
    rw [ih]
    ring

theorem additive_increment_indep_of_x (n : Nat) (omega : Omega) (x y : Int) :
    (additiveCocycle f).phi n omega x - x =
    (additiveCocycle f).phi n omega y - y := by
  induction n generalizing omega x y with
  | zero => rfl
  | succ n ih =>
    simp [additiveCocycle]
    rw [ih (ns.theta omega) (x + f omega) (y + f omega)]
    ring

theorem additive_cumulative_sum (n : Nat) (omega : Omega) (x : Int) :
    (additiveCocycle f).phi n omega x = x +
      (Nat.recOn n (fun _ => 0)
        (fun m ih w => ih (ns.theta w) + f w)) omega := by
  induction n generalizing omega x with
  | zero => rfl
  | succ n ih =>
    simp [additiveCocycle]
    rw [ih (ns.theta omega) (x + f omega)]
    simp [Nat.recOn]
    ring

theorem additive_sum_of_observables (g : Omega -> Int) (n : Nat) (omega : Omega) (x : Int) :
    (additiveCocycle f).phi n omega x + (additiveCocycle g).phi n omega 0 =
    (additiveCocycle (fun w => f w + g w)).phi n omega x := by
  induction n generalizing omega x with
  | zero => simp [additiveCocycle]
  | succ n ih =>
    simp [additiveCocycle]
    rw [ih (ns.theta omega) (x + f omega)]
    congr 1
    simp

/-! Multiplicative cocycle properties -/

variable (g : Omega -> Nat) (gpos : forall w, g w > 0)

theorem multiplicative_one_step (omega : Omega) (x : Nat) :
    (multiplicativeCocycle g gpos).phi 1 omega x = x * g omega := by
  simp [multiplicativeCocycle, Cocycle.oneStep]

theorem multiplicative_succ (n : Nat) (omega : Omega) (x : Nat) :
    (multiplicativeCocycle g gpos).phi (n+1) omega x =
    (multiplicativeCocycle g gpos).phi n (ns.theta omega) (x * g omega) := by
  simp [multiplicativeCocycle, NoiseSpace.iterate]

theorem multiplicative_positive (n : Nat) (omega : Omega) (x : Nat) (hx : x > 0) :
    (multiplicativeCocycle g gpos).phi n omega x > 0 := by
  induction n generalizing omega x with
  | zero => simpa [multiplicativeCocycle] using hx
  | succ n ih =>
    simp [multiplicativeCocycle]
    apply ih (ns.theta omega) (x * g omega)
    exact mul_pos hx (gpos omega)

theorem multiplicative_product_formula (n : Nat) (omega : Omega) (x : Nat) :
    (multiplicativeCocycle g gpos).phi n omega x = x *
      (Nat.recOn n (fun _ => 1)
        (fun m ih w => ih (ns.theta w) * g w)) omega := by
  induction n generalizing omega x with
  | zero => simp [multiplicativeCocycle]
  | succ n ih =>
    simp [multiplicativeCocycle]
    rw [ih (ns.theta omega) (x * g omega)]
    simp [Nat.recOn, mul_assoc]

/-! Subadditive cocycle structure -/

structure SubadditiveCocycle (Omega : Type) (ns : NoiseSpace Omega) where
  a : Nat -> Omega -> RR
  a_zero : forall omega, a 0 omega = 0
  subadd : forall (n m : Nat) (omega : Omega),
    a (n+m) omega <= a n omega + a m (ns.iterate n omega)

/-! Finite-time Lyapunov exponent (1D) -/

def finiteTimeLyapunov1D (A : Omega -> RR) (n : Nat) (omega : Omega) : RR :=
  if h : n = 0 then 0
  else
    let rec sumLog (k : Nat) (w : Omega) (acc : RR) : RR :=
      match k with
      | 0 => acc
      | m+1 => sumLog m (ns.theta w) (acc + Real.log (|A w|))
    (1 / (n : RR)) * sumLog n omega 0

theorem lyapunov_isometry (A : Omega -> RR) (hA : forall w, |A w| = 1) (n : Nat) (omega : Omega) :
    finiteTimeLyapunov1D A n omega = 0 := by
  unfold finiteTimeLyapunov1D
  split
  · rfl
  · rename_i h
    have hlog : forall w, Real.log (|A w|) = 0 := by
      intro w; rw [hA w, Real.log_one]
    have hsum : forall (k : Nat) (w : Omega),
      (Nat.recOn k (fun _ acc => acc)
        (fun m ih w' acc => ih (ns.theta w') (acc + Real.log (|A w'|)))) w 0 = 0 := by
      intro k w
      induction k generalizing w with
      | zero => rfl
      | succ k ih' =>
        simp
        rw [hlog w]
        apply ih'
    simp [hlog, hsum, mul_zero]

theorem lyapunov_constant (C : RR) (n : Nat) (omega : Omega) (hn : n > 0) :
    finiteTimeLyapunov1D (fun _ => C) n omega = Real.log (|C|) := by
  unfold finiteTimeLyapunov1D
  have hn0 : n != 0 := by omega
  simp [hn0]
  have hsum : forall (k : Nat) (w : Omega),
    (Nat.recOn k (fun _ acc => acc)
      (fun m ih w' acc => ih (ns.theta w') (acc + Real.log (|C|)))) w 0 = (k : RR) * Real.log (|C|) := by
    intro k w
    induction k generalizing w with
    | zero => rfl
    | succ k ih' =>
      simp
      rw [ih' (ns.theta w)]
      ring
  simp [hsum]
  field_simp [show (n : RR) != 0 from by
    intro hzero
    have : (n : Nat) = 0 := by exact_mod_cast hzero
    omega]
  ring

/-! eval verification -/

def testF : Int -> Int := fun w => if w % 2 = 0 then 1 else -1

#eval "=== Core.Laws: Cocycle identities ==="
#eval (additiveCocycle testF).phi 0 0 42
#eval (additiveCocycle testF).phi 1 0 42
#eval (additiveCocycle testF).phi 5 0 10

def testG : Int -> Nat := fun _ => 2
def testGpos : forall w, testG w > 0 := by intro w; omega

#eval (multiplicativeCocycle testG testGpos).phi 3 0 1
#eval (multiplicativeCocycle testG testGpos).phi 4 0 1

#eval finiteTimeLyapunov1D (fun (_ : Int) => (2 : RR)) 10 0

end MiniRandomDynamicalSystems
""")

print("Core/Laws.lean done!")
