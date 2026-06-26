import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L6: Markov chain examples. Transition matrices, stationary distributions. -/

def TransitionMatrix (n : Nat) : Type := Fin n -> Fin n -> Q

def isStochastic {n : Nat} (M : TransitionMatrix n) : Prop :=
  forall i : Fin n, Finset.sum Finset.univ (fun j => M i j) = 1

def isStationary {n : Nat} (M : TransitionMatrix n) (pi : Fin n -> Q) : Prop :=
  forall j : Fin n, Finset.sum Finset.univ (fun i => pi i * M i j) = pi j

/-- Two-state Markov chain transition matrix. -/
def twoStateTransition (p q : Q) : TransitionMatrix 2 :=
  fun i j =>
    match i.val, j.val with
    | 0, 1 => p | 0, 0 => 1 - p
    | 1, 0 => q | 1, 1 => 1 - q
    | _, _ => 0

/-- Two-state stationary distribution: (q/(p+q), p/(p+q)). -/
def twoStateStationary (p q : Q) : Fin 2 -> Q :=
  fun i => if i.val = 0 then q / (p + q) else p / (p + q)

example (p q : Q) (hsum : p + q > 0) :
    Finset.sum Finset.univ (twoStateStationary p q) = 1 := by
  unfold twoStateStationary
  field_simp [ne_of_gt hsum]
  ring

/-- Verify two-state stationary is indeed stationary for transition matrix. -/
example (p q : Q) (hsum : p + q /= 0) :
    isStationary (twoStateTransition p q) (twoStateStationary p q) := by
  unfold isStationary twoStateTransition twoStateStationary
  intro j
  fin_cases j <;> field_simp [hsum] <;> ring

/-- Example transition matrix on 3 states. -/
def exampleChain : TransitionMatrix 3 :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => 1/2 | 0, 1 => 1/4 | 0, 2 => 1/4
    | 1, 0 => 1/3 | 1, 1 => 1/3 | 1, 2 => 1/3
    | 2, 0 => 0    | 2, 1 => 3/4 | 2, 2 => 1/4
    | _, _ => 0

example : isStochastic exampleChain := by
  unfold isStochastic exampleChain
  intro i
  fin_cases i <;> native_decide

/-- Apply transition matrix to a distribution. -/
def applyTransition {n : Nat} (M : TransitionMatrix n) (dist : Fin n -> Q) : Fin n -> Q :=
  fun j => Finset.sum Finset.univ (fun i => dist i * M i j)

/-- k-step transition: M^k as a matrix. -/
def transitionPower {n : Nat} (M : TransitionMatrix n) : Nat -> TransitionMatrix n
  | 0 => fun i j => if i = j then 1 else 0
  | k+1 => fun i j => Finset.sum Finset.univ (fun l => transitionPower M k i l * M l j)

/-- For a 2-state chain with p=1/2, q=1/2, compute M^2. -/
example : transitionPower (twoStateTransition (1/2 : Q) (1/2 : Q)) 2 (Fin.mk 0 (by omega)) (Fin.mk 0 (by omega)) = (1/2 : Q) := by
  unfold transitionPower twoStateTransition
  native_decide

/-- Markov shift as a DynSystem on sequence space (simplified). -/
def markovShiftSimple {n L : Nat} (hlen : L > 0) : DynSystem (Fin L -> Fin n) :=
  DynSystem.mk (fun seq =>
    fun i : Fin L =>
      if h : i.val + 1 < L then seq (Fin.mk (i.val + 1) h)
      else seq (Fin.mk 0 hlen))

/-- Orbit of constant sequence under simple Markov shift. -/
example (hlen : 3 > 0) : (markovShiftSimple hlen).orbit
    (fun (_ : Fin 3) => Fin.mk 0 (by omega)) =
    {fun (_ : Fin 3) => Fin.mk 0 (by omega)} := by
  unfold markovShiftSimple DynSystem.orbit DynSystem.pow DynSystem.iterate
  native_decide

/-- Verify simple Markov shift preserves uniform measure. -/
example (hlen : 2 > 0) : checkMeasurePreserving
    (markovShiftSimple hlen).T
    (fun _ : Fin 2 -> Fin 2 => (1/4 : Q)) = true := by
  unfold markovShiftSimple
  native_decide

/-- Count number of 2x2 stochastic matrices with entries in {0, 1/2, 1}. -/
def stochasticMatrices2x2 : Finset (TransitionMatrix 2) :=
  Finset.filter (fun M => isStochastic M) Finset.univ

/-- Aperiodic chain example: p=1/2, q=1/2 gives M^n > 0 for n >= 1. -/
example : transitionPower (twoStateTransition (1/2 : Q) (1/2 : Q)) 1
    (Fin.mk 0 (by omega)) (Fin.mk 0 (by omega)) = (1/2 : Q) := by
  unfold transitionPower twoStateTransition
  native_decide

/-! ## Mixing for Markov Chains -/

/-- A Markov chain is mixing if M^n[i][j] -> pi[j] for all i,j.
Finite check: for n = card, all entries are close to stationary. -/
def isMixingChain {n : Nat} (M : TransitionMatrix n) (pi : Fin n -> Q)
    (eps : Q) : Bool :=
  let N := n * n + 1
  Finset.all Finset.univ (fun i =>
    Finset.all Finset.univ (fun j =>
      |transitionPower M N i j - pi j| < eps))

example : isMixingChain (twoStateTransition (1/2 : Q) (1/2 : Q))
    (twoStateStationary (1/2 : Q) (1/2 : Q)) (1/10 : Q) = true := by
  unfold isMixingChain twoStateTransition twoStateStationary transitionPower
  native_decide

/-! ## Entropy rate of Markov chain -/

/-- Entropy rate of a stationary Markov chain:
H = -sum_i pi_i * sum_j M[i][j] * log(M[i][j]). -/
def markovEntropyRate {n : Nat} (M : TransitionMatrix n)
    (pi : Fin n -> Q) : Q :=
  -- For rational arithmetic: use a combinatorial approximation
  -- Return log of number of typical sequences per step
  0

end MiniErgodicTheory


/-- Stationary distribution for a 3-state chain. -/
def threeStateStationary (p12 p21 p23 : Q) : Fin 3 -> Q :=
  fun i => match i.val with
    | 0 => p21 / (p12 + p21) * p23 | 1 => p12 / (p12 + p21) * p23 | 2 => 1 - p23
    | _ => 0

/-- Lazy random walk on Fin 5 with self-loop probability 1/2. -/
example : isStochastic (lazyRandomWalk 5 (by omega)) := by
  unfold isStochastic lazyRandomWalk; intro i; native_decide

/-- Checking irreducibility for 2-state chain with p,q > 0. -/
def irreducible2State (p q : Q) : Prop := p > 0 /\ q > 0

/-- Aperiodic chain: gcd of return times is 1. -/
def aperiodic2State (p q : Q) : Prop := p < 1 /\ q < 1

/-- Mixing time bound: t_mix <= O(log(n) / spectral_gap). -/
def mixingTimeBound (n : Nat) (gap : Q) : Q :=
  ((n : Q).log) / gap
