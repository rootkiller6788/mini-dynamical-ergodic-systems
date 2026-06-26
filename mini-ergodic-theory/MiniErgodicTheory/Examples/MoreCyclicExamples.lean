import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! Additional cyclic and shift examples for L6. -/

example : timeAverage (DynSystem.mk (fun (x : Fin 8) =>
    if h : x.val + 1 < 8 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 8 => (x.val : Q)) 8 (Fin.mk 0 (by omega)) = (7/2 : Q) := by
  unfold timeAverage DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

example : spaceAverage (ProbabilityMeasure.ofWeights (fun _ : Fin 8 => (1/8 : Q))
    (by intro x; norm_num) (by native_decide)) (fun x : Fin 8 => (x.val : Q)) = (7/2 : Q) := by
  unfold spaceAverage; native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 9) =>
    if h : x.val + 1 < 9 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 9 => (x.val : Q)) 9 (Fin.mk 0 (by omega)) = (4 : Q) := by
  unfold timeAverage DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 10) =>
    if h : x.val + 1 < 10 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 10 => ((x.val : Q) ^ 2)) 10 (Fin.mk 0 (by omega)) =
    spaceAverage (ProbabilityMeasure.ofWeights (fun _ : Fin 10 => (1/10 : Q))
      (by intro x; norm_num) (by native_decide)) (fun x : Fin 10 => ((x.val : Q) ^ 2)) := by
  unfold timeAverage spaceAverage DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

example : checkErgodic (fun (x : Fin 9) =>
    if h : x.val + 1 < 9 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 9 => (1/9 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 10) =>
    if h : x.val + 1 < 10 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 10 => (1/10 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 11) =>
    if h : x.val + 1 < 11 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 11 => (1/11 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 12) =>
    if h : x.val + 1 < 12 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 12 => (1/12 : Q)) = true := by native_decide

example : checkMeasurePreserving (fun (x : Fin 11) =>
    if h : x.val + 1 < 11 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 11 => (1/11 : Q)) = true := by native_decide

example : checkMeasurePreserving (fun (x : Fin 12) =>
    if h : x.val + 1 < 12 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ : Fin 12 => (1/12 : Q)) = true := by native_decide

example : KoopmanOperator
    (DynSystem.mk (fun (x : Fin 4) =>
      if h : x.val + 1 < 4 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 4 => (x.val : Q)) (Fin.mk 2 (by omega)) = (3 : Q) := by
  unfold KoopmanOperator DynSystem.mk; native_decide

example : KoopmanOperator
    (DynSystem.mk (fun (x : Fin 5) =>
      if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 5 => (x.val : Q)) (Fin.mk 3 (by omega)) = (4 : Q) := by
  unfold KoopmanOperator DynSystem.mk; native_decide

example : ergodicSum (DynSystem.mk (fun (x : Fin 3) =>
    if h : x.val + 1 < 3 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 3 => (x.val : Q)) 6 (Fin.mk 0 (by omega)) = (6 : Q) := by
  unfold ergodicSum DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

example : ergodicSum (DynSystem.mk (fun (x : Fin 4) =>
    if h : x.val + 1 < 4 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun x : Fin 4 => (x.val : Q)) 8 (Fin.mk 0 (by omega)) = (12 : Q) := by
  unfold ergodicSum DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 2) % 6) (Nat.mod_lt _ (by omega)))
  T.orbitSize (Fin.mk 0 (by omega)) = 3 := by
  intro T; unfold T DynSystem.orbitSize DynSystem.orbit DynSystem.mk
    DynSystem.pow DynSystem.iterate; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 3) % 6) (Nat.mod_lt _ (by omega)))
  T.orbitSize (Fin.mk 0 (by omega)) = 2 := by
  intro T; unfold T DynSystem.orbitSize DynSystem.orbit DynSystem.mk
    DynSystem.pow DynSystem.iterate; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 4) % 6) (Nat.mod_lt _ (by omega)))
  T.orbitSize (Fin.mk 0 (by omega)) = 3 := by
  intro T; unfold T DynSystem.orbitSize DynSystem.orbit DynSystem.mk
    DynSystem.pow DynSystem.iterate; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 1) % 6) (Nat.mod_lt _ (by omega)))
  checkErgodic T.T (fun _ : Fin 6 => (1/6 : Q)) = true := by
  intro T; unfold T DynSystem.mk; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 2) % 6) (Nat.mod_lt _ (by omega)))
  checkErgodic T.T (fun _ : Fin 6 => (1/6 : Q)) = false := by
  intro T; unfold T DynSystem.mk; native_decide

example : let T : DynSystem (Fin 6) := DynSystem.mk (fun x =>
    Fin.mk ((x.val + 4) % 6) (Nat.mod_lt _ (by omega)))
  checkErgodic T.T (fun _ : Fin 6 => (1/6 : Q)) = false := by
  intro T; unfold T DynSystem.mk; native_decide

end MiniErgodicTheory
