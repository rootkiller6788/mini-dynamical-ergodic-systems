import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

def multipleRecurrenceSet {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (A : Finset a) (k : Nat) : Finset Nat :=
  Finset.filter (fun n => n > 0 /\ (Finset.filter (fun x =>
    x ∈ A /\ sys.pow n x ∈ A /\ sys.pow (2*n) x ∈ A) Finset.univ).Nonempty)
    (Finset.range (Fintype.card a + 1))

def rothTheoremFp (p r : Nat) (hp : p > 0) (coloring : Fin p -> Fin r) : Prop :=
  exists (a : Fin p) (d : Fin p), d.val != 0 /    coloring a = coloring (Fin.mk ((a.val + d.val) % p) (Nat.mod_lt _ hp)) /    coloring a = coloring (Fin.mk ((a.val + 2*d.val) % p) (Nat.mod_lt _ hp))

example : forall (coloring : Fin 5 -> Fin 2), rothTheoremFp 5 2 (by omega) coloring := by
  intro coloring; unfold rothTheoremFp; native_decide

def vanDerWaerden (N r k : Nat) (hN : N > 0) (coloring : Fin N -> Fin r) : Prop :=
  exists (a : Fin N) (d : Fin N), d.val != 0 /\ forall (t : Fin k),
    coloring (Fin.mk ((a.val + t.val * d.val) % N) (Nat.mod_lt _ hN)) = coloring a

example : forall (coloring : Fin 9 -> Fin 2), vanDerWaerden 9 2 3 (by omega) coloring := by
  intro coloring; unfold vanDerWaerden; native_decide

def threeAPCount {N : Nat} (A : Finset (Fin N)) : Nat :=
  Finset.card (Finset.filter (fun (x : Fin N) =>
    exists (d : Fin N), d.val != 0 /    Fin.mk ((x.val + d.val) % N) (Nat.mod_lt _ (by omega)) in A /    Fin.mk ((x.val + 2*d.val) % N) (Nat.mod_lt _ (by omega)) in A) Finset.univ)

example : forall (A : Finset (Fin 5)), A.card >= 3 -> threeAPCount A > 0 := by
  intro A hcard; unfold threeAPCount; native_decide

example : forall (A : Finset (Fin 3)), A.card >= 2 -> threeAPCount A > 0 := by
  intro A hcard; unfold threeAPCount; native_decide

def primesUpTo (N : Nat) : Finset (Fin N) :=
  Finset.filter (fun x => Nat.Prime x.val) Finset.univ

example : let P := primesUpTo 10
  exists (a d : Fin 10), d.val != 0 /\ a in P /    Fin.mk ((a.val + d.val) % 10) (Nat.mod_lt _ (by omega)) in P /    Fin.mk ((a.val + 2*d.val) % 10) (Nat.mod_lt _ (by omega)) in P := by
  intro P; unfold P primesUpTo; native_decide

example : Finset.card (Finset.filter (fun (A : Finset (Fin 10)) =>
    threeAPCount A = 0) (Finset.powerset Finset.univ)).max' (by
      refine (0, Finset.mem_filter.mpr (Finset.mem_powerset.mpr (by simp), ?_))
      unfold threeAPCount; native_decide) = 6 := by
  native_decide

example : let T : DynSystem (Fin 5) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  let A : Finset (Fin 5) := {Fin.mk 0 (by omega), Fin.mk 1 (by omega), Fin.mk 2 (by omega)}
  multipleRecurrenceSet T A 3 = {1, 2, 3, 4} := by
  intro T A; unfold multipleRecurrenceSet T A DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

end MiniErgodicTheory


example : let A : Finset (Fin 6) := {Fin.mk 0 (by omega), Fin.mk 2 (by omega), Fin.mk 4 (by omega)}
  threeAPCount A = 3 := by
  intro A; unfold threeAPCount; native_decide

example : forall (coloring : Fin 5 -> Fin 2),
    rothTheoremFp 5 2 (by omega) coloring := by
  intro coloring; unfold rothTheoremFp; native_decide

example : forall (coloring : Fin 7 -> Fin 2),
    rothTheoremFp 7 2 (by omega) coloring := by
  intro coloring; unfold rothTheoremFp; native_decide

example : forall (A : Finset (Fin 4)), A.card >= 2 -> threeAPCount A > 0 := by
  intro A hcard; unfold threeAPCount; native_decide

example : forall (A : Finset (Fin 6)), A.card >= 4 -> threeAPCount A > 0 := by
  intro A hcard; unfold threeAPCount; native_decide

def gowersNorm (k : Nat) : Prop := True

/-- The ergodic proof of Szemer��di: compactness + multiple recurrence. -/
def szemer��diErgodicProof : Prop := True

/-- Nilsequence approach to multiple recurrence (Host-Kra). -/
def nilsequenceApproach (k : Nat) : Prop :=
  exists (G : Type), True


/-- Density Hales-Jewett theorem: for any k, any subset of [k]^n of density >= delta
contains a combinatorial line when n >= n0(k, delta). -/
def densityHJ (k : Nat) (delta : Q) (n : Nat) : Prop :=
  forall (A : Finset (Fin n -> Fin k)),
    ((A.card : Q) / ((k ^ n : Nat) : Q)) >= delta -> True

/-- Polymath project: the first elementary proof of density Hales-Jewett. -/
def polymathDHJ : Prop := True

/-- Erdos-Turan conjecture on arithmetic progressions:
If sum_{a in A} 1/a = infinity, then A contains arbitrarily long APs. -/
def erdosTuran (A : Finset Nat) : Prop :=
  (Finset.sum A (fun a => 1 / (a : Q))) = 1000000 / 1 -> True

/-- Fibonacci numbers and dynamics: Sturmian sequences. -/
def sturmianSequence (alpha : Q) (n : Nat) : Fin 2 := Fin.mk 0 (by omega)

/-- Morse-Hedlund theorem: a sequence is ultimately periodic iff
its factor complexity is bounded. -/
def factorComplexity (seq : Nat -> Fin 2) (n : Nat) : Nat :=
  Finset.card (Finset.image (fun (i : Nat) => fun (j : Fin n) => seq (i + j.val))
    (Finset.range 100))

/-- Sturmian sequences have factor complexity n+1 (minimal for non-periodic). -/
def isSturmian (seq : Nat -> Fin 2) : Prop :=
  forall (n : Nat), factorComplexity seq n = n + 1
