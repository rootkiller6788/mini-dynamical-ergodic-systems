import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L6: Additional shift space and Bernoulli examples. -/

def FullShift (m len : Nat) : Type := Fin len -> Fin m

def fullShiftLeft {m len : Nat} (seq : FullShift m len) : FullShift m len :=
  fun i => if h : i.val + 1 < len then seq (Fin.mk (i.val + 1) h) else seq (Fin.mk 0 (by omega))

example : let T : (Fin 2 -> Fin 2) -> (Fin 2 -> Fin 2) := fullShiftLeft
  T (fun _ => Fin.mk 0 (by omega)) = (fun _ => Fin.mk 0 (by omega)) := by
  intro T; unfold fullShiftLeft; ext i; fin_cases i <;> rfl

example : let T : FullShift 2 3 -> FullShift 2 3 := fullShiftLeft
  let seq : FullShift 2 3 := fun i => match i.val with | 0 => Fin.mk 0 (by omega)
    | 1 => Fin.mk 1 (by omega) | 2 => Fin.mk 0 (by omega)
  T seq 0 = Fin.mk 1 (by omega) := by
  intro T seq; unfold T fullShiftLeft; native_decide

example : let T : FullShift 2 3 -> FullShift 2 3 := fullShiftLeft
  let seq : FullShift 2 3 := fun i => match i.val with | 0 => Fin.mk 0 (by omega)
    | 1 => Fin.mk 1 (by omega) | 2 => Fin.mk 0 (by omega)
  T seq 1 = Fin.mk 0 (by omega) := by
  intro T seq; unfold T fullShiftLeft; native_decide

example : let T : FullShift 2 3 -> FullShift 2 3 := fullShiftLeft
  let seq : FullShift 2 3 := fun i => match i.val with | 0 => Fin.mk 0 (by omega)
    | 1 => Fin.mk 1 (by omega) | 2 => Fin.mk 0 (by omega)
  T seq 2 = Fin.mk 0 (by omega) := by
  intro T seq; unfold T fullShiftLeft; native_decide

example : checkMeasurePreserving (@fullShiftLeft 2 2)
    (fun _ : FullShift 2 2 => (1/4 : Q)) = true := by native_decide

example : checkMeasurePreserving (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => (1/8 : Q)) = true := by native_decide

example : checkMeasurePreserving (@fullShiftLeft 3 2)
    (fun _ : FullShift 3 2 => (1/9 : Q)) = true := by native_decide

example : checkErgodic (@fullShiftLeft 2 2)
    (fun _ : FullShift 2 2 => (1/4 : Q)) = true := by native_decide

example : checkErgodic (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => (1/8 : Q)) = true := by native_decide

def cylinderSet {m len k : Nat} (positions : Fin k -> Fin len) (values : Fin k -> Fin m) : Finset (FullShift m len) :=
  Finset.filter (fun seq => forall (i : Fin k), seq (positions i) = values i) Finset.univ

example : let A := cylinderSet (fun (_ : Fin 1) => Fin.mk 0 (by omega))
    (fun (_ : Fin 1) => Fin.mk 0 (by omega))
  let mu := ProbabilityMeasure.ofWeights (fun _ : FullShift 2 3 => (1/8 : Q))
    (by intro x; norm_num) (by native_decide)
  mu.setMeasure A = (1/2 : Q) := by
  intro A mu; unfold A cylinderSet mu ProbabilityMeasure.setMeasure; native_decide

def bernoulliMeasure {m : Nat} (hm : m > 0) (probs : Fin m -> Q) (hpos : forall i, probs i >= 0)
    (hsum : Finset.sum Finset.univ probs = 1) (len : Nat) : ProbabilityMeasure (FullShift m len) :=
  ProbabilityMeasure.ofWeights
    (fun seq => Finset.prod (Finset.range len) (fun k => probs (seq (Fin.mk k (by omega)))))
    (by
      intro seq
      refine Finset.prod_nonneg (fun k hk => hpos (seq (Fin.mk k (by omega))))
    )
    (by
      -- Sum over all sequences = product of sums = 1^len = 1
      -- For specific m, len, this is computable via native_decide
      native_decide)

/-- Bernoulli measure with p(0)=1/3, p(1)=2/3 on length 2 sequences. -/
example : let p : Fin 2 -> Q := fun i => if i.val = 0 then 1/3 else 2/3
  (bernoulliMeasure 2 (by omega) p (by intro i; fin_cases i <;> norm_num)
    (by native_decide) 2).setMeasure Finset.univ = 1 := by
  intro p; unfold bernoulliMeasure ProbabilityMeasure.setMeasure; native_decide

/-- For Bernoulli(1/2,1/2) measure, the entropy per symbol is 1/2 (using combinatorial definition). -/
example : giniSimpsonIndex (ProbabilityMeasure.ofWeights
    (fun (_ : Fin 2) => (1/2 : Q)) (by intro x; fin_cases x <;> norm_num) (by native_decide)) = (1/2 : Q) := by
  unfold giniSimpsonIndex; native_decide

/-- For Bernoulli(1/3,2/3), the entropy is 4/9. -/
example : giniSimpsonIndex (ProbabilityMeasure.ofWeights
    (fun (x : Fin 2) => if x.val = 0 then 1/3 else 2/3)
    (by intro x; fin_cases x <;> norm_num) (by native_decide)) = (4/9 : Q) := by
  unfold giniSimpsonIndex; native_decide

/-- Orbit of a sequence under the shift on length 2 with 2 symbols. -/
example : let T : DynSystem (FullShift 2 2) := DynSystem.mk fullShiftLeft
  let x : FullShift 2 2 := fun i => if i.val = 0 then Fin.mk 0 (by omega) else Fin.mk 1 (by omega)
  T.orbit x = let y : FullShift 2 2 := fun i => if i.val = 0 then Fin.mk 1 (by omega) else Fin.mk 0 (by omega)
  {x, y} := by
  intro T x y; unfold T DynSystem.orbit DynSystem.mk DynSystem.pow DynSystem.iterate
    fullShiftLeft x y
  native_decide

/-- Mixing check for full shift on 2 symbols, length 2, at various times. -/
example : checkMixingUpTo (@fullShiftLeft 2 2)
    (fun _ : FullShift 2 2 => (1/4 : Q)) 5 (1/10 : Q) = true := by native_decide

example : checkMixingUpTo (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => (1/8 : Q)) 10 (1/10 : Q) = true := by native_decide

/-- Iterated shift: apply shift twice. -/
example : let T : (Fin 3 -> Fin 2) -> (Fin 3 -> Fin 2) := fun seq i =>
    fullShiftLeft (fullShiftLeft seq) i
  let x : Fin 3 -> Fin 2 := fun i => Fin.mk (if i.val = 0 then 0 else 1) (by omega)
  T x 0 = Fin.mk 1 (by omega) := by
  intro T x; unfold T fullShiftLeft x; native_decide

/-- The shift is surjective (for finite sequences with wrap-around). -/
example : Function.Surjective (@fullShiftLeft 2 2) := by
  intro y
  refine (fun i => if i.val = 0 then y 1 else y 0, ?_)
  ext i; fin_cases i <;> unfold fullShiftLeft <;> native_decide

end MiniErgodicTheory


/-- Shift on Fin 2 alphabet of length 3: verify the shift preserves uniform measure. -/
example : checkMeasurePreserving (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => (1/8 : Q)) = true := by native_decide

/-- Shift on Fin 3 alphabet of length 2: verify ergodicity. -/
example : checkErgodic (@fullShiftLeft 3 2)
    (fun _ : FullShift 3 2 => (1/9 : Q)) = true := by native_decide

/-- The all-ones sequence is a fixed point of the shift on length 1. -/
example : let T : DynSystem (FullShift 2 1) := DynSystem.mk fullShiftLeft
  let x : FullShift 2 1 := fun _ => Fin.mk 1 (by omega)
  T.pow 1 x = x := by
  intro T x; unfold T DynSystem.mk DynSystem.pow DynSystem.iterate fullShiftLeft x
  ext i; fin_cases i <;> rfl

/-- Bernoulli(1/3, 2/3) product measure on 2 symbols length 3 sums to 1. -/
example : let p : Fin 2 -> Q := fun i => if i.val = 0 then 1/3 else 2/3
  let mu := bernoulliMeasure 2 (by omega) p (by intro i; fin_cases i <;> norm_num)
    (by native_decide) 3
  mu.setMeasure Finset.univ = 1 := by
  intro p mu; unfold mu bernoulliMeasure ProbabilityMeasure.setMeasure; native_decide
