import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L7: Shannon entropy and Kolmogorov-Sinai entropy (finite/combinatorial). -/

def giniSimpsonIndex {a : Type} [Fintype a] [DecidableEq a] (p : ProbabilityMeasure a) : Q :=
  1 - Finset.sum Finset.univ (fun x => p.mu x * p.mu x)

theorem giniSimpson_uniform (n : Nat) (hn : n > 0) : giniSimpsonIndex
    (ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])) = 1 - 1 / (n : Q) := by
  unfold giniSimpsonIndex; simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn]; ring

theorem giniSimpson_dirac {a : Type} [Fintype a] [DecidableEq a] (x0 : a) :
    giniSimpsonIndex (ProbabilityMeasure.dirac x0) = 0 := by
  unfold giniSimpsonIndex ProbabilityMeasure.dirac
  simp [Finset.sum_ite_eq, Finset.mem_univ]

def entropyCombinatorial {a : Type} [Fintype a] [DecidableEq a] (p : ProbabilityMeasure a) : Q :=
  Finset.sum Finset.univ (fun x => p.mu x * (1 - p.mu x))

theorem entropyCombinatorial_uniform (n : Nat) (hn : n > 0) : entropyCombinatorial
    (ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])) = 1 - 1 / (n : Q) := by
  unfold entropyCombinatorial; simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn]; ring

theorem entropy_nonneg {a : Type} [Fintype a] [DecidableEq a] (p : ProbabilityMeasure a) :
    entropyCombinatorial p >= 0 := by
  unfold entropyCombinatorial
  refine Finset.sum_nonneg (fun x hx => ?_)
  have hpx1 : p.mu x <= 1 := by
    have hsum := p.sum_one
    have hle : p.mu x <= Finset.sum Finset.univ p.mu :=
      Finset.single_le_sum_of_mem (fun y hy => p.nonneg y) (Finset.mem_univ x)
    linarith
  nlinarith [p.nonneg x, hpx1]

def partitionEntropyCombinatorial {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) (alpha : Finset (Finset a)) : Q :=
  Finset.sum alpha (fun A => p.setMeasure A * (1 - p.setMeasure A))

def ksEntropyFinite {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (p : ProbabilityMeasure a) : Q :=
  Finset.sum Finset.univ (fun x => p.mu x * ((sys.orbitSize x : Q)))

def topologicalEntropyFinite {a : Type} [Fintype a] [DecidableEq a] (sys : DynSystem a) : Q :=
  let sizes := Finset.image (fun x : a => sys.orbitSize x) Finset.univ
  (Finset.sup' sizes (by
    apply Finset.Nonempty.image (fun x => sys.orbitSize x)
    exact Finset.univ_nonempty) id : Q)

example (n : Nat) (hn : n > 0) : topologicalEntropyFinite
    (DynSystem.mk (fun (x : Fin n) =>
      if h : x.val + 1 < n then Fin.mk (x.val + 1) h else Fin.mk 0 hn)) = (n : Q) := by
  unfold topologicalEntropyFinite; native_decide

example (n : Nat) (hn : n > 0) : topologicalEntropyFinite
    (DynSystem.mk (id : Fin n -> Fin n)) = (1 : Q) := by
  unfold topologicalEntropyFinite; native_decide

def totalVariation {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) : Q :=
  (1/2 : Q) * Finset.sum Finset.univ (fun x => |p.mu x - q.mu x|)

example {a : Type} [Fintype a] [DecidableEq a] (x0 x1 : a) (h : x0 != x1) :
    totalVariation (ProbabilityMeasure.dirac x0) (ProbabilityMeasure.dirac x1) = 1 := by
  unfold totalVariation ProbabilityMeasure.dirac; simp [h, Finset.sum_ite_eq, Finset.mem_univ]; ring

def ksEntropyFullShift (m L : Nat) (hm : m > 0) (hL : L > 0) : Q := (L : Q) * (1 - 1 / (m : Q))

example : ksEntropyFullShift 2 3 (by omega) (by omega) = (3/2 : Q) := by
  unfold ksEntropyFullShift; norm_num

example (n : Nat) (hn : n > 0) : ksEntropyFinite
    (DynSystem.mk (fun (x : Fin n) =>
      if h : x.val + 1 < n then Fin.mk (x.val + 1) h else Fin.mk 0 hn))
    (ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])) = (n : Q) := by
  unfold ksEntropyFinite; native_decide

end MiniErgodicTheory
