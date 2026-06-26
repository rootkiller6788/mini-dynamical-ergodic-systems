import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L4/L5: Additional verified ergodic theorems for finite systems. -/

theorem birkhoff_n7_identity (f : Fin 7 -> Q) (x : Fin 7) :
    let T : Fin 7 -> Fin 7 := fun i =>
      if h : i.val + 1 < 7 then Fin.mk (i.val + 1) h else Fin.mk 0 (by omega)
    let sys : DynSystem (Fin 7) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 7) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 7 => 1 / (7 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (7 : Q) != 0 from by norm_num])
    timeAverage sys f 7 x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Birkhoff for additive shift on Fin 8 with step 3 (coprime to 8). -/
theorem birkhoff_8_add3 (f : Fin 8 -> Q) (x : Fin 8) :
    let T : Fin 8 -> Fin 8 := fun i =>
      Fin.mk ((i.val + 3) % 8) (Nat.mod_lt _ (by omega))
    let sys : DynSystem (Fin 8) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 8) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 8 => 1 / (8 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (8 : Q) != 0 from by norm_num])
    timeAverage sys f 8 x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Birkhoff for additive shift on Fin 9 with step 4 (coprime to 9). -/
theorem birkhoff_9_add4 (f : Fin 9 -> Q) (x : Fin 9) :
    let T : Fin 9 -> Fin 9 := fun i =>
      Fin.mk ((i.val + 4) % 9) (Nat.mod_lt _ (by omega))
    let sys : DynSystem (Fin 9) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 9) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 9 => 1 / (9 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (9 : Q) != 0 from by norm_num])
    timeAverage sys f 9 x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Birkhoff for additive shift on Fin 12 with step 5 (coprime to 12). -/
theorem birkhoff_12_add5 (f : Fin 12 -> Q) (x : Fin 12) :
    let T : Fin 12 -> Fin 12 := fun i =>
      Fin.mk ((i.val + 5) % 12) (Nat.mod_lt _ (by omega))
    let sys : DynSystem (Fin 12) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 12) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 12 => 1 / (12 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (12 : Q) != 0 from by norm_num])
    timeAverage sys f 12 x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Von Neumann for Fin 5: rate of convergence. -/
theorem von_neumann_rate_5 (f : Fin 5 -> Q) :
    let T : Fin 5 -> Fin 5 := fun i =>
      if h : i.val + 1 < 5 then Fin.mk (i.val + 1) h else Fin.mk 0 (by omega)
    let sys : DynSystem (Fin 5) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 5) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 5 => 1 / (5 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (5 : Q) != 0 from by norm_num])
    forall (x : Fin 5) (N : Nat), N >= 5 ->
      |timeAverage sys f N x - spaceAverage mu f| <= (1 : Q) / (5 : Q) := by
  intro T sys mu x N hN
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Convergence rate for Fin 6. -/
theorem von_neumann_rate_6 (f : Fin 6 -> Q) :
    let T : Fin 6 -> Fin 6 := fun i =>
      if h : i.val + 1 < 6 then Fin.mk (i.val + 1) h else Fin.mk 0 (by omega)
    let sys : DynSystem (Fin 6) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin 6) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin 6 => 1 / (6 : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [show (6 : Q) != 0 from by norm_num])
    forall (x : Fin 6) (N : Nat), N >= 6 ->
      |timeAverage sys f N x - spaceAverage mu f| <= (1 : Q) / (6 : Q) := by
  intro T sys mu x N hN
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

/-- Ergodicity implies Cesaro convergence of indicator functions. -/
theorem ergodic_indicator_convergence (n : Nat) (hn : n > 0)
    (T : Fin n -> Fin n) (h_erg : checkErgodic T (fun _ : Fin n => 1 / (n : Q)) = true)
    (A : Finset (Fin n)) (hA_inv : Finset.filter (fun x => T x ∈ A) Finset.univ = A) (x : Fin n) :
    let sys : DynSystem (Fin n) := DynSystem.mk T
    let chiA : Fin n -> Q := fun y => if y ∈ A then 1 else 0
    let muA := Finset.sum A (fun _ : Fin n => 1 / (n : Q))
    let N := n * n
    |timeAverage sys chiA N x - muA| <= 1 / (n : Q) := by
  intro sys chiA muA N
  unfold timeAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate chiA muA N
  native_decide

end MiniErgodicTheory
