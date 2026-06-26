import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

theorem birkhoff_cyclic_n_exact (n : Nat) (hn : n > 0) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    forall (f : Fin n -> Q) (x : Fin n),
      let sys : DynSystem (Fin n) := DynSystem.mk T
      timeAverage sys f n x = (Finset.sum Finset.univ f) / (n : Q) := by
  intro T f x sys
  unfold timeAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate
  native_decide

theorem ergodic_decomposition_cyclic (n : Nat) (hn : n > 0) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    let sys : DynSystem (Fin n) := DynSystem.mk T
    forall (x : Fin n), sys.orbitSize x = n := by
  intro T sys x
  unfold sys DynSystem.orbitSize DynSystem.orbit DynSystem.mk T DynSystem.pow DynSystem.iterate
  native_decide

theorem unique_ergodicity_cyclic (n : Nat) (hn : n > 0) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    let mu : ProbabilityMeasure (Fin n) := ProbabilityMeasure.ofWeights
      (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    forall (x : Fin n) (f : Fin n -> Q),
      let sys : DynSystem (Fin n) := DynSystem.mk T
      timeAverage sys f n x = spaceAverage mu f := by
  intro T mu x f sys
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

theorem mixing_cyclic_uniform (n : Nat) (hn : n > 2) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    forall (A B : Finset (Fin n)) (k : Nat), k >= n ->
      let mu_A := (A.card : Q) / (n : Q)
      let mu_B := (B.card : Q) / (n : Q)
      let corr := Finset.sum (Finset.filter (fun x => (fun i => T^[k] i) x ∈ A) Finset.univ cap B)
        (fun _ => (1 : Q) / (n : Q))
      |corr - mu_A * mu_B| <= 1 / (n : Q) := by
  intro T A B k hk mu_A mu_B corr
  unfold mu_A mu_B corr T
  native_decide

theorem kac_lemma_finite (n : Nat) (hn : n > 0) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    let mu : ProbabilityMeasure (Fin n) := ProbabilityMeasure.ofWeights
      (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    forall (A : Finset (Fin n)), mu.setMeasure A > 0 ->
      let expected_return := (n : Q) / (A.card : Q)
      expected_return <= (n : Q) := by
  intro T mu A hpos expected_return
  unfold expected_return
  have hcard_pos : A.card > 0 := by
    by_contra hzero; have hcard0 : A.card = 0 := by omega
    have hzero_meas : mu.setMeasure A = 0 := by
      unfold ProbabilityMeasure.setMeasure mu; simp [hcard0]
    linarith
  have hcard_le_n : A.card <= n := Finset.card_le_univ A
  have h_div_pos : (0 : Q) < A.card := by exact_mod_cast hcard_pos
  apply (div_le_one ?_).trans
  . exact_mod_cast hcard_le_n
  . exact_mod_cast hcard_pos

end MiniErgodicTheory
