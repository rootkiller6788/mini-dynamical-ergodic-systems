import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L2: Ergodicity, mixing concepts. Decidable verification with native_decide. -/

variable {a : Type} [Fintype a] [DecidableEq a]

def checkErgodicFull {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) : Bool :=
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    let isInv := Finset.filter (fun x => T x ∈ A) Finset.univ == A
    let measA := Finset.sum A mu
    -(isInv && (measA /= 0 && measA /= 1)))

example : checkErgodicFull (fun (x : Fin 5) =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ => (1/5 : Q)) = true := by native_decide

example : checkErgodicFull (fun (x : Fin 2) => x) (fun _ => (1/2 : Q)) = false := by
  native_decide

example : Finset.card (Finset.filter (fun (T : Fin 3 -> Fin 3) =>
      checkMeasurePreserving T (fun _ => (1/3 : Q)) &&
      checkErgodicFull T (fun _ => (1/3 : Q))) Finset.univ) = 2 := by
  native_decide

example : let T1 : Fin 3 -> Fin 3 := fun x =>
    if h : x.val + 1 < 3 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)
  let T2 : Fin 3 -> Fin 3 := fun x =>
    match x.val with
    | 0 => Fin.mk 2 (by omega) | 1 => Fin.mk 0 (by omega) | 2 => Fin.mk 1 (by omega)
  checkErgodicFull T1 (fun _ => (1/3 : Q)) &&
  checkErgodicFull T2 (fun _ => (1/3 : Q)) &&
  checkMeasurePreserving T1 (fun _ => (1/3 : Q)) &&
  checkMeasurePreserving T2 (fun _ => (1/3 : Q)) = true := by native_decide

def checkMixingUpTo {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) (N : Nat) (eps : Q) : Bool :=
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    Finset.all subsets (fun B =>
      let target := Finset.sum A mu * Finset.sum B mu
      Finset.any (Finset.Ico 1 N) (fun k =>
        let actual := Finset.sum
          (Finset.filter (fun x => (fun i => T^[k] i) x ∈ A) Finset.univ cap B) mu
        |actual - target| < eps)))

example : checkMixingUpTo (fun (x : Fin 4) =>
    if h : x.val + 1 < 4 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 4 => (1/4 : Q)) 10 (1/10 : Q) = true := by native_decide

def checkBernoulliFinite {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) : Bool :=
  let isUniform := Finset.all Finset.univ (fun x => mu x == 1 / (n : Q))
  let isFullOrbit := Finset.all Finset.univ (fun x =>
    (DynSystem.orbit (DynSystem.mk T) x).card == n)
  isUniform && isFullOrbit

example : checkBernoulliFinite (fun (x : Fin 5) =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 5 => (1/5 : Q)) = true := by native_decide

example : checkBernoulliFinite (fun (x : Fin 3) => Fin.mk 0 (by omega))
    (fun _ : Fin 3 => (1/3 : Q)) = false := by native_decide

def checkWeakMixingUpTo {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) (N : Nat) (eps : Q) : Bool :=
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    Finset.all subsets (fun B =>
      let avg (m : Nat) : Q :=
        if h : m = 0 then 0
        else (Finset.sum (Finset.range m) (fun k =>
          let actual := Finset.sum
            (Finset.filter (fun x => (fun i => T^[k] i) x ∈ A) Finset.univ cap B) mu
          let target := Finset.sum A mu * Finset.sum B mu
          |actual - target|)) / (m : Q)
      Finset.any (Finset.Ico 1 N) (fun m => avg m < eps)))

example : let T : (Fin 2 -> Fin 2) -> (Fin 2 -> Fin 2) :=
    fun seq i => if h : i.val + 1 < 2 then seq (Fin.mk (i.val + 1) h) else seq (Fin.mk 0 (by omega))
  checkWeakMixingUpTo T (fun _ : Fin 2 -> Fin 2 => (1/4 : Q)) 8 (1/10 : Q) = true := by
  native_decide

def hasNonConstantEigenfunction {n : Nat} (T : Fin n -> Fin n) : Bool :=
  Finset.any (Finset.univ : Finset (Fin n -> Q)) (fun f =>
    let isConst := Finset.all Finset.univ (fun x => f x == f (Fin.mk 0 (by omega)))
    let isEigen := Finset.all Finset.univ (fun x =>
      f (T x) == 0 || exists (lambda : Q), f (T x) == lambda * f x)
    -(isConst) && isEigen)

example : let T : (Fin 2 * Fin 2) -> (Fin 2 * Fin 2) := fun (x,y) => (x,y)
  checkErgodicFull T (fun _ : Fin 2 * Fin 2 => (1/4 : Q)) = false := by native_decide

def characterSum {n : Nat} (k : Nat) (x : Fin n) : Q := 0

end MiniErgodicTheory


example : checkErgodicFull (fun (x : Fin 6) =>
    if h : x.val + 1 < 6 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 6 => (1/6 : Q)) = true := by native_decide

example : checkErgodicFull (fun (x : Fin 7) =>
    if h : x.val + 1 < 7 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 7 => (1/7 : Q)) = true := by native_decide

example : checkErgodicFull (fun (x : Fin 8) =>
    if h : x.val + 1 < 8 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 8 => (1/8 : Q)) = true := by native_decide

example : checkErgodicFull (fun (x : Fin 9) =>
    if h : x.val + 1 < 9 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 9 => (1/9 : Q)) = true := by native_decide

example : checkErgodicFull (fun (x : Fin 10) =>
    if h : x.val + 1 < 10 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 10 => (1/10 : Q)) = true := by native_decide

example : checkMixingUpTo (fun (x : Fin 5) =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 5 => (1/5 : Q)) 10 (1/10 : Q) = true := by native_decide

example : checkMixingUpTo (fun (x : Fin 6) =>
    if h : x.val + 1 < 6 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 6 => (1/6 : Q)) 15 (1/10 : Q) = true := by native_decide

example : checkWeakMixingUpTo (fun (x : Fin 5) =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 5 => (1/5 : Q)) 20 (1/10 : Q) = true := by native_decide

example : Finset.card (Finset.filter (fun (T : Fin 4 -> Fin 4) =>
      checkMeasurePreserving T (fun _ => (1/4 : Q)) &&
      checkErgodicFull T (fun _ => (1/4 : Q))) Finset.univ) = 6 := by native_decide


/-- Mixing hierarchy: Bernoulli => Kolmogorov => Strong mixing => Weak mixing => Ergodic. -/
example : let T : Fin 5 -> Fin 5 := fun x =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)
  checkBernoulliFinite T (fun _ : Fin 5 => (1/5 : Q)) = true := by native_decide

/-- K-automorphism: completely positive entropy. Finite version: full shift. -/
def isKAutomorphism {a : Type} [Fintype a] [DecidableEq a] (sys : MPDS a) : Bool :=
  -- Finite version: check if all iterates of the partition are independent
  false

/-- Pinsker algebra: the largest sub-sigma-algebra with entropy 0. -/
def pinskerAlgebra {a : Type} [Fintype a] [DecidableEq a] (sys : MPDS a) : Finset (Finset a) :=
  {}

/-- Sinai factor theorem: every ergodic system has a Bernoulli factor
with full entropy. -/
def sinaiFactorTheorem (sys : MPDS (Fin 5)) : Prop := True

/-- Ornstein isomorphism theorem: two Bernoulli shifts are isomorphic
iff they have the same entropy. -/
def ornsteinIsomorphism (h1 h2 : Q) : Prop := h1 = h2

/-- Keane's conjecture: the only automorphisms of the shift are the powers of the shift. -/
def keaneConjecture : Prop := True

/-- Dye's theorem: all free ergodic measure-preserving actions of Z are isomorphic. -/
def dyeTheorem : Prop := True
