import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

def cyclicShift {n : Nat} (hn : n > 0) : Fin n -> Fin n :=
  fun i => if h : i.val + 1 < n then Fin.mk (i.val + 1) h else Fin.mk 0 hn

def cyclicSystem (n : Nat) (hn : n > 0) : DynSystem (Fin n) :=
  DynSystem.mk (cyclicShift hn)

def uniformMeasure (n : Nat) (hn : n > 0) : ProbabilityMeasure (Fin n) :=
  ProbabilityMeasure.ofWeights
    (fun _ : Fin n => 1 / (n : Q))
    (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
    (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt (by exact_mod_cast hn)])

def cyclicMPDS (n : Nat) (hn : n > 0) : MPDS (Fin n) :=
  MPDS.mk' (cyclicShift hn) (uniformMeasure n hn) (by
    intro A
    unfold ProbabilityMeasure.setMeasure uniformMeasure
    native_decide)

example : (cyclicSystem 5 (by omega)).orbit (Fin.mk 0 (by omega)) = Finset.univ := by
  unfold cyclicSystem DynSystem.orbit cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : (cyclicSystem 7 (by omega)).orbitSize (Fin.mk 3 (by omega)) = 7 := by
  unfold cyclicSystem DynSystem.orbitSize DynSystem.orbit
    cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example (n : Nat) (hn : n > 0) : checkMeasurePreserving (cyclicShift hn)
    (fun _ : Fin n => 1 / (n : Q)) = true := by
  unfold checkMeasurePreserving cyclicShift
  native_decide

example : checkErgodic (cyclicShift (by omega : 7 > 0))
    (fun _ : Fin 7 => (1/7 : Q)) = true := by native_decide

example : checkErgodic (cyclicShift (by omega : 4 > 0))
    (fun _ : Fin 4 => (1/4 : Q)) = true := by native_decide

example : timeAverage (cyclicSystem 5 (by omega))
    (fun _ : Fin 5 => (3 : Q)) 10 (Fin.mk 0 (by omega)) = (3 : Q) := by
  unfold timeAverage cyclicSystem cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : timeAverage (cyclicSystem 5 (by omega))
    (fun x : Fin 5 => (x.val : Q)) 5 (Fin.mk 0 (by omega)) = (2 : Q) := by
  unfold timeAverage cyclicSystem cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : spaceAverage (uniformMeasure 5 (by omega))
    (fun x : Fin 5 => (x.val : Q)) = (2 : Q) := by
  unfold spaceAverage uniformMeasure
  native_decide

example : timeAverage (cyclicSystem 6 (by omega))
    (fun x : Fin 6 => (x.val : Q)) 6 (Fin.mk 0 (by omega)) =
    spaceAverage (uniformMeasure 6 (by omega)) (fun x : Fin 6 => (x.val : Q)) := by
  unfold timeAverage spaceAverage cyclicSystem cyclicShift
    DynSystem.pow DynSystem.iterate uniformMeasure
  native_decide

example : (cyclicSystem 5 (by omega)).pow 5 (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega) := by
  unfold cyclicSystem DynSystem.pow DynSystem.iterate cyclicShift
  native_decide

example : (cyclicSystem 5 (by omega)).pow 1 (Fin.mk 0 (by omega)) /= Fin.mk 0 (by omega) := by
  unfold cyclicSystem DynSystem.pow DynSystem.iterate cyclicShift
  native_decide

example : (cyclicSystem 5 (by omega)).pow 2 (Fin.mk 0 (by omega)) /= Fin.mk 0 (by omega) := by
  unfold cyclicSystem DynSystem.pow DynSystem.iterate cyclicShift
  native_decide

end MiniErgodicTheory


example : checkErgodic (fun (x : Fin 11) =>
    if h : x.val + 1 < 11 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 11 => (1/11 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 12) =>
    if h : x.val + 1 < 12 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 12 => (1/12 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 13) =>
    if h : x.val + 1 < 13 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 13 => (1/13 : Q)) = true := by native_decide

example : timeAverage (cyclicSystem 8 (by omega))
    (fun x : Fin 8 => (x.val : Q)) 8 (Fin.mk 0 (by omega)) = (7/2 : Q) := by
  unfold timeAverage cyclicSystem cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : timeAverage (cyclicSystem 9 (by omega))
    (fun x : Fin 9 => (x.val : Q)) 9 (Fin.mk 0 (by omega)) = (4 : Q) := by
  unfold timeAverage cyclicSystem cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : timeAverage (cyclicSystem 10 (by omega))
    (fun x : Fin 10 => (x.val : Q)) 10 (Fin.mk 0 (by omega)) = (9/2 : Q) := by
  unfold timeAverage cyclicSystem cyclicShift DynSystem.pow DynSystem.iterate
  native_decide

example : (cyclicSystem 11 (by omega)).pow 11 (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega) := by
  unfold cyclicSystem DynSystem.pow DynSystem.iterate cyclicShift; native_decide

example : (cyclicSystem 12 (by omega)).pow 12 (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega) := by
  unfold cyclicSystem DynSystem.pow DynSystem.iterate cyclicShift; native_decide


/-- Verify ergodicity for larger cyclic systems. -/
example : checkErgodic (cyclicShift (by omega : 14 > 0))
    (fun _ : Fin 14 => (1/14 : Q)) = true := by native_decide

example : checkErgodic (cyclicShift (by omega : 15 > 0))
    (fun _ : Fin 15 => (1/15 : Q)) = true := by native_decide

example : checkErgodic (cyclicShift (by omega : 16 > 0))
    (fun _ : Fin 16 => (1/16 : Q)) = true := by native_decide

/-- The cyclic shift is a bijection. -/
example : let f := cyclicShift (by omega : 7 > 0)
  Function.Bijective f := by
  intro f; unfold f cyclicShift
  constructor
  . intro x y h; apply Fin.ext; have hx := x.is_lt; have hy := y.is_lt
    unfold Fin.mk at h; injection h with hval; omega
  . intro y
    refine (Fin.mk ((y.val + 6) % 7) (Nat.mod_lt _ (by omega)), ?_)
    apply Fin.ext; unfold cyclicShift
    by_cases h : ((y.val + 6) % 7) + 1 < 7
    . simp [h]; omega
    . have : ((y.val + 6) % 7) + 1 = 7 := by
        have hmod : ((y.val + 6) % 7) < 7 := Nat.mod_lt _ (by omega)
        omega
      simp [h, this]; omega

/-- Orbit size for cyclic shift on Fin 20 is 20. -/
example : (cyclicSystem 20 (by omega)).orbitSize (Fin.mk 0 (by omega)) = 20 := by
  unfold cyclicSystem DynSystem.orbitSize DynSystem.orbit
    cyclicShift DynSystem.pow DynSystem.iterate
  native_decide
