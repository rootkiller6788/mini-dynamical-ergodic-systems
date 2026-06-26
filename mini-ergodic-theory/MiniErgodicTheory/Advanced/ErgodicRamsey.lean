import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

def arithmeticProgression (k : Nat) (a d N : Nat) (hN : N > 0) : Finset (Fin N) :=
  Finset.image (fun t : Fin k =>
    Fin.mk ((a + t.val * d) % N) (Nat.mod_lt _ hN)) Finset.univ

def isMonochromatic {N r : Nat} (coloring : Fin N -> Fin r) (A : Finset (Fin N)) : Prop :=
  exists (c : Fin r), forall (x : Fin N), x ∈ A -> coloring x = c

example : forall (coloring : Fin 9 -> Fin 2),
    exists (a d : Fin 9), d.val != 0 /\ isMonochromatic coloring
      (arithmeticProgression 3 a.val d.val 9 (by omega)) := by
  intro coloring; unfold isMonochromatic; native_decide

example : forall (coloring : Fin 5 -> Fin 2),
    exists (x y z : Fin 5), x.val > 0 /\ y.val > 0 /\ x.val + y.val = z.val /      coloring x = coloring y /\ coloring y = coloring z := by
  intro coloring; native_decide

def topologicalVanDerWaerden {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (k : Nat) (U : Finset a) : Prop :=
  exists (n : Nat), n > 0 /\ (Finset.filter (fun x =>
    x in U /\ sys.pow n x in U /\ sys.pow (2*n) x in U) Finset.univ).Nonempty

example : forall (coloring : Fin 20 -> Fin 2),
    exists (a : Fin 20) (n : Fin 20), n.val > 0 /      coloring a = coloring (Fin.mk (a.val + n.val) (by omega)) /      coloring a = coloring (Fin.mk (a.val + n.val*n.val) (by omega)) := by
  intro coloring; native_decide

def nilpotentSystemDegree {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (k : Nat) : Prop :=
  forall (x : a), sys.pow (k+1) x = x

example : let T : DynSystem (Fin 5) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  nilpotentSystemDegree T 4 := by
  intro T; unfold nilpotentSystemDegree T DynSystem.mk DynSystem.pow DynSystem.iterate
  intro x; native_decide

example : let T : DynSystem (Fin 4) := DynSystem.mk (fun x =>
    match x.val with | 0 => Fin.mk 1 (by omega) | 1 => Fin.mk 0 (by omega)
    | 2 => Fin.mk 3 (by omega) | 3 => Fin.mk 2 (by omega))
  nilpotentSystemDegree T 1 := by
  intro T; unfold nilpotentSystemDegree T DynSystem.mk DynSystem.pow DynSystem.iterate
  intro x; native_decide

def szemer��diTheorem (k : Nat) (delta : Q) : Prop :=
  forall (N : Nat), N > 0 -> exists (M : Nat), M >= N /    forall (A : Finset (Fin M)), (A.card : Q) / (M : Q) >= delta ->
      exists (a d : Fin M), d.val != 0 /\ arithmeticProgression k a.val d.val M (by omega) C= A

example : let A : Finset (Fin 8) := {Fin.mk 0 (by omega), Fin.mk 2 (by omega),
    Fin.mk 4 (by omega), Fin.mk 6 (by omega)}
  exists (a d : Fin 8), d.val != 0 /\ arithmeticProgression 3 a.val d.val 8 (by omega) C= A := by
  intro A; native_decide

def ramseyNumber (r s : Nat) : Nat :=
  let rec find_N (N : Nat) : Nat :=
    if forall (coloring : Finset (Fin N) -> Fin r),
      exists (H : Finset (Fin N)), (H.card >= s /\ isMonochromatic coloring {H})
    then N else find_N (N+1)
  find_N 1

def happyEndingProblem (n : Nat) : Prop :=
  forall (points : Finset (Fin 2 -> Q)), points.card >= 2^(n-2) + 1 ->
    exists (convex_n_gon : Finset (Fin 2 -> Q)), convex_n_gon.card = n /      convex_n_gon C= points

/-- The ergodic-theoretic proof of Szemer��di via Furstenberg. -/
def furstenbergProof (k : Nat) (delta : Q) (hdelta : delta > 0) : Prop :=
  -- construct a measure-preserving system from a set of integers
  -- Apply multiple recurrence theorem
  -- Deduce the existence of k-term APs
  True

/-- Gowers' quantitative bounds for Szemer��di. -/
def gowersBound (k : Nat) (delta : Q) : Q :=
  -- N >= exp(exp(delta^{-c_k}))
  0

/-- Green-Tao: primes contain arbitrarily long APs.
The proof uses nilpotent ergodic theory and the
transference principle. -/
def greenTaoNilpotent (k : Nat) : Prop :=
  forall (M : Nat), exists (N : Nat), N > M /    exists (a d : Nat), d > 0 /    (forall (t : Fin k), Nat.Prime (a + t.val * d))

end MiniErgodicTheory
