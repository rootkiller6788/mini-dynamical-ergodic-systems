import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L4/L5: Pigeonhole recurrence for finite systems. Complete proofs. -/

section PigeonholeRecurrence

variable {a : Type} [Fintype a] [DecidableEq a]

theorem pigeonhole_repetition (sys : DynSystem a) (x : a) :
    exists (i j : Nat), i < j /\ j <= Fintype.card a + 1 /\ sys.pow i x = sys.pow j x := by
  let N := Fintype.card a + 1
  have hNgt : N > Fintype.card a := by omega
  by_contra h_norep
  push_neg at h_norep
  have h_inj : forall (i j : Nat), i < j -> j < N -> sys.pow i x != sys.pow j x := by
    intro i j hi_lt_j hj_lt_N
    exact h_norep i j hi_lt_j (by omega)
  have h_card : Finset.card (Finset.image (fun n : Nat => sys.pow n x)
      (Finset.range N)) = N := by
    apply Finset.card_image_of_injective (Finset.range N)
    intro i j hi hj h_eq
    by_cases h_eq_ij : i = j
    . exact h_eq_ij
    . by_cases h_lt : i < j
      . exfalso; exact h_inj i j h_lt (Finset.mem_range.mp hj) h_eq
      . have h_gt : j < i := Nat.lt_of_le_of_ne (Nat.le_of_not_gt h_lt) h_eq_ij.symm
        exfalso; exact h_inj j i h_gt (Finset.mem_range.mp hi) h_eq.symm
  have h_bound : Finset.card (Finset.image (fun n : Nat => sys.pow n x)
      (Finset.range N)) <= Fintype.card a := Finset.card_le_univ _
  omega

theorem periodic_from_repetition (sys : DynSystem a) (x : a) :
    exists (i n : Nat), n > 0 /\ n <= Fintype.card a + 1 /    sys.pow n (sys.pow i x) = sys.pow i x := by
  rcases pigeonhole_repetition sys x with (i, j, hi_lt_j, hj_le, h_eq)
  refine (i, j - i, Nat.sub_pos_of_lt hi_lt_j, by omega, ?_)
  calc
    sys.pow (j - i) (sys.pow i x) = sys.pow ((j - i) + i) x := by rw [DynSystem.pow_add]
    _ = sys.pow j x := by rw [Nat.sub_add_cancel (Nat.le_of_lt hi_lt_j)]
    _ = sys.pow i x := h_eq.symm

theorem orbit_size_le_card (sys : DynSystem a) (x : a) :
    sys.orbitSize x <= Fintype.card a :=
  Finset.card_le_univ (sys.orbit x)

theorem orbit_contains_x (sys : DynSystem a) (x : a) : x in sys.orbit x := by
  unfold DynSystem.orbit
  refine Finset.mem_image.mpr (0, Finset.mem_range.mpr (by omega), ?_)
  simp

theorem orbit_nonempty (sys : DynSystem a) (x : a) : (sys.orbit x).Nonempty := by
  refine Finset.Nonempty.image (fun n : Nat => sys.pow n x)
    (Finset.range (Fintype.card a + 1)) (0, Finset.mem_range.mpr (by omega))

theorem orbit_size_pos (sys : DynSystem a) (x : a) : sys.orbitSize x > 0 := by
  have h := orbit_nonempty sys x
  exact Finset.card_pos.mpr h

theorem orbit_closed_under_T (sys : DynSystem a) (x : a) :
    forall (y : a), y in sys.orbit x -> sys.T y in sys.orbit x := by
  intro y hy
  rcases Finset.mem_image.mp hy with (n, hn, rfl)
  refine Finset.mem_image.mpr (n+1, Finset.mem_range.mpr (by omega), ?_)
  simp [DynSystem.pow_succ]

theorem orbit_T_image_subset_orbit (sys : DynSystem a) (x : a) :
    Finset.image sys.T (sys.orbit x) C= sys.orbit x := by
  intro y hy
  rcases Finset.mem_image.mp hy with (z, hz, rfl)
  exact orbit_closed_under_T sys x z hz

end PigeonholeRecurrence

/-! ## Verified examples -/

example : let T : DynSystem (Fin 5) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  forall (x : Fin 5), T.pow 5 x = x := by
  intro T x
  unfold T DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : let T : DynSystem (Fin 7) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 7 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  forall (x : Fin 7), T.orbitSize x = 7 := by
  intro T x
  unfold T DynSystem.orbitSize DynSystem.orbit DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : let T : DynSystem (Fin 4) := DynSystem.mk (fun x =>
    match x.val with
    | 0 => Fin.mk 1 (by omega) | 1 => Fin.mk 0 (by omega)
    | 2 => Fin.mk 3 (by omega) | 3 => Fin.mk 2 (by omega))
  forall (x : Fin 4), T.pow 2 x = x := by
  intro T x
  unfold T DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 2) % 6) (Nat.mod_lt _ (by omega)))
  forall (x : Fin 6), T.pow 3 x = x := by
  intro T x
  unfold T DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : let T : DynSystem (Fin 8) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 4) % 8) (Nat.mod_lt _ (by omega)))
  forall (x : Fin 8), T.pow 2 x = x := by
  intro T x
  unfold T DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

end MiniErgodicTheory
