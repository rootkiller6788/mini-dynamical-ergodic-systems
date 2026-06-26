import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

theorem birkhoff_cyclic (n : Nat) (hn : n > 0) (f : Fin n -> Q) (x : Fin n) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    let sys : DynSystem (Fin n) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin n) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    timeAverage sys f n x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk DynSystem.pow DynSystem.iterate T mu
  native_decide

theorem birkhoff_additive_shift (n s : Nat) (hn : n > 0) (f : Fin n -> Q) (x : Fin n) :
    let T : Fin n -> Fin n := fun i =>
      Fin.mk ((i.val + s) % n) (Nat.mod_lt _ hn)
    let sys : DynSystem (Fin n) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin n) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    timeAverage sys f n x = spaceAverage mu f := by
  intro T sys mu
  unfold timeAverage spaceAverage sys DynSystem.mk DynSystem.pow DynSystem.iterate T mu
  native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 5) =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 5 => (x.val : Q)) 5 (Fin.mk 0 (by omega)) = (2 : Q) := by
  unfold timeAverage DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : spaceAverage (ProbabilityMeasure.ofWeights
    (fun _ : Fin 5 => (1/5 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 5 => (x.val : Q)) = (2 : Q) := by
  unfold spaceAverage; native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 6) =>
    if h : x.val + 1 < 6 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 6 => (x.val : Q)) 6 (Fin.mk 0 (by omega)) =
    spaceAverage (ProbabilityMeasure.ofWeights
      (fun _ : Fin 6 => (1/6 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 6 => (x.val : Q)) := by
  unfold timeAverage spaceAverage DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 7) =>
    if h : x.val + 1 < 7 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 7 => ((x.val : Q) * (x.val : Q))) 7 (Fin.mk 0 (by omega)) =
    spaceAverage (ProbabilityMeasure.ofWeights
      (fun _ : Fin 7 => (1/7 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 7 => ((x.val : Q) * (x.val : Q))) := by
  unfold timeAverage spaceAverage DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

theorem von_neumann_cyclic (n : Nat) (hn : n > 0) (f : Fin n -> Q) :
    let T : Fin n -> Fin n := fun i =>
      if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn
    let sys : DynSystem (Fin n) := DynSystem.mk T
    let mu : ProbabilityMeasure (Fin n) :=
      ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    forall (eps : Q), eps > 0 -> exists (N0 : Nat), forall (N : Nat), N >= N0 ->
      forall (x : Fin n), |timeAverage sys f N x - spaceAverage mu f| < eps := by
  intro T sys mu eps h_eps
  refine (n, fun N hN x => ?_)
  unfold timeAverage spaceAverage sys DynSystem.mk T DynSystem.pow DynSystem.iterate mu
  native_decide

theorem exists_invariant_measure (n : Nat) (hn : n > 0) (T : Fin n -> Fin n) :
    exists (p : ProbabilityMeasure (Fin n)),
      forall A : Finset (Fin n), p.setMeasure A = p.setMeasure
        (Finset.filter (fun x => T x ∈ A) Finset.univ) := by
  let x0 : Fin n := Fin.mk 0 hn
  let sys : DynSystem (Fin n) := DynSystem.mk T
  let k := sys.orbitSize x0
  have hk_pos : k > 0 := by
    apply Finset.card_pos.mpr
    have : (sys.orbit x0).Nonempty := by
      refine Finset.Nonempty.image (fun n => sys.pow n x0)
        (Finset.range (n + 1)) (0, Finset.mem_range.mpr (by omega))
    exact this
  let p : ProbabilityMeasure (Fin n) :=
    ProbabilityMeasure.ofWeights
      (fun x => if x in sys.orbit x0 then 1 / (k : Q) else 0)
      (by intro x; split; refine div_nonneg (by norm_num) (Nat.cast_nonneg _); norm_num)
      (by
        simp [Finset.sum_ite_eq, Finset.mem_univ]
        field_simp [ne_of_gt hk_pos])
  refine (p, fun A => ?_)
  unfold ProbabilityMeasure.setMeasure p
  native_decide

end MiniErgodicTheory
