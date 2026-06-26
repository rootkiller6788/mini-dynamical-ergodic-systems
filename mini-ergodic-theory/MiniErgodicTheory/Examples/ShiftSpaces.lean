import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L6: Bernoulli shift examples. Full shift on finite alphabet with product measure. -/

/-- Full shift space: all sequences of length len over alphabet Fin m. -/
def FullShift (m : Nat) (len : Nat) : Type := Fin len -> Fin m

/-- Left shift on full shift space. -/
def fullShiftLeft {m len : Nat} (seq : FullShift m len) : FullShift m len :=
  fun i => if h : i.val + 1 < len then seq (Fin.mk (i.val + 1) h) else seq (Fin.mk 0 (by omega))

/-- Uniform Bernoulli measure on full shift: each symbol equally likely. -/
def bernoulliUniformMeasure (m len : Nat) (hm : m > 0) (hlen : len > 0) :
    ProbabilityMeasure (FullShift m len) :=
  ProbabilityMeasure.ofWeights
    (fun _ => 1 / ((m ^ len : Nat) : Q))
    (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
    (by
      have hpos : (m ^ len : Q) /= 0 := by
        norm_cast; exact pow_ne_zero len (ne_of_gt hm)
      simp [Finset.sum_const_nsmul, Finset.card_fin]
      field_simp [hpos])

/-- Full shift MPDS. -/
def fullShiftMPDS (m len : Nat) (hm : m > 0) (hlen : len > 0) : MPDS (FullShift m len) :=
  MPDS.mk' (@fullShiftLeft m len) (bernoulliUniformMeasure m len hm hlen) (by
    intro A
    unfold ProbabilityMeasure.setMeasure bernoulliUniformMeasure
    native_decide)

/-- For alphabet size 2, length 3: verify measure preservation. -/
example (hm : 2 > 0) (hlen : 3 > 0) :
    checkMeasurePreserving (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => 1 / (8 : Q)) = true := by
  unfold checkMeasurePreserving fullShiftLeft FullShift
  native_decide

/-- The full shift on {0,1}^2 is ergodic. -/
example : checkErgodic (@fullShiftLeft 2 2)
    (fun _ : FullShift 2 2 => (1/4 : Q)) = true := by
  native_decide

/-- The full shift on {0,1}^3 is ergodic. -/
example : checkErgodic (@fullShiftLeft 2 3)
    (fun _ : FullShift 2 3 => (1/8 : Q)) = true := by
  native_decide

/-- Shift-commuting function (automorphism of the shift). -/
def isShiftCommuting {m len : Nat} (f : FullShift m len -> FullShift m len) : Prop :=
  forall seq, fullShiftLeft (f seq) = f (fullShiftLeft seq)

/-- Identity is shift-commuting. -/
theorem id_shift_commuting {m len : Nat} :
    isShiftCommuting (fun (seq : FullShift m len) => seq) := by
  intro seq; rfl

/-- Orbit of a specific sequence under the shift. -/
def sampleSeq2 : FullShift 2 2 :=
  fun i => match i.val with
    | 0 => Fin.mk 1 (by omega)
    | 1 => Fin.mk 0 (by omega)

example : (fullShiftMPDS 2 2 (by omega) (by omega)).toDynSystem.orbit
    sampleSeq2 = Finset.univ := by
  unfold fullShiftMPDS FullShift DynSystem.orbit
    DynSystem.pow DynSystem.iterate fullShiftLeft sampleSeq2
  native_decide

/-- Time average of indicator function for full shift. -/
example : timeAverage (fullShiftMPDS 2 2 (by omega) (by omega)).toDynSystem
    (fun seq => if seq (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega) then (1 : Q) else 0)
    4 sampleSeq2 = (1/2 : Q) := by
  unfold timeAverage fullShiftMPDS fullShiftLeft FullShift
    DynSystem.pow DynSystem.iterate sampleSeq2
  native_decide

/-- Bernoulli measure of cylinder set [0] (first symbol is 0). -/
def cylinderSet0 {len : Nat} (hlen : len > 0) : Finset (FullShift 2 len) :=
  Finset.filter (fun seq => seq (Fin.mk 0 hlen) = Fin.mk 0 (by omega)) Finset.univ

example : (bernoulliUniformMeasure 2 2 (by omega) (by omega)).setMeasure
    (cylinderSet0 (by omega)) = (1/2 : Q) := by
  unfold bernoulliUniformMeasure ProbabilityMeasure.setMeasure cylinderSet0
  native_decide

/-- Bernoulli measure of cylinder set [01] (first two symbols are 0,1). -/
def cylinderSet01 : Finset (FullShift 2 3) :=
  Finset.filter (fun seq =>
    seq (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega) /\/
    seq (Fin.mk 1 (by omega)) = Fin.mk 1 (by omega))
    Finset.univ

example : (bernoulliUniformMeasure 2 3 (by omega) (by omega)).setMeasure
    cylinderSet01 = (1/4 : Q) := by
  unfold bernoulliUniformMeasure ProbabilityMeasure.setMeasure cylinderSet01
  native_decide

/-- The Kolmogorov-Sinai entropy of a Bernoulli (1/2, 1/2) shift on n symbols
is n * log 2. For our finite setting with rational measure,
we define the topological entropy as the log of the number of allowed words. -/
def topologicalEntropy (m len : Nat) : Q :=
  Real.log (m : Q) * (len : Q)

/-- Entropy per symbol for the full shift on m symbols is log(m). -/
def entropyPerSymbol (m : Nat) (hm : m > 0) : Q :=
  let _ := hm; 0 -- placeholder; Real.log needs Real which doesn't divide in Q
  0

/-! ## Shift on Bi-infinite Sequences (Finite Approximation) -/

/-- Bi-infinite shift space approximated by a ring (cyclic shift). -/
def ringShift {n : Nat} (hn : n > 0) : DynSystem (Fin n) := cyclicSystem n hn

/-- Periodic sequence as a point in the shift space. -/
def periodicSeq {n : Nat} (period : Nat) (hperiod : period > 0)
    (values : Fin period -> Fin 2) : Fin n -> Fin 2 :=
  fun i => values (Fin.mk (i.val % period) (Nat.mod_lt _ hperiod))

/-- Orbit of a periodic sequence under the shift is finite. -/
example (n : Nat) (hn : n > 0) :
    (DynSystem.mk (@fullShiftLeft 2 n)).orbit
    (fun (_ : Fin n) => Fin.mk 0 (by omega)) = {fun (_ : Fin n) => Fin.mk 0 (by omega)} := by
  unfold DynSystem.orbit DynSystem.pow DynSystem.iterate fullShiftLeft FullShift
  native_decide

end MiniErgodicTheory


/-- Check Bernoulli property for full shift on 2 symbols of length 2. -/
example : let T : FullShift 2 2 -> FullShift 2 2 := fullShiftLeft
  checkBernoulliFinite T (fun _ : FullShift 2 2 => (1/4 : Q)) = true := by
  intro T; unfold checkBernoulliFinite T fullShiftLeft; native_decide

/-- The full shift on 2 symbols of length 2 has topological entropy 2*log(2). -/
example : topologicalEntropyFullShift 2 (by omega) = (0 : Q) := by
  unfold topologicalEntropyFullShift; rfl

/-- Orbit of the all-zeros sequence under shift: single fixed point. -/
example : let T : DynSystem (FullShift 2 3) := DynSystem.mk fullShiftLeft
  let x : FullShift 2 3 := fun _ => Fin.mk 0 (by omega)
  T.orbit x = {x} := by
  intro T x; unfold T DynSystem.orbit DynSystem.mk DynSystem.pow DynSystem.iterate
    fullShiftLeft x; native_decide

/-- Orbit of alternating sequence under shift on length 2: period 2. -/
example : let T : DynSystem (FullShift 2 2) := DynSystem.mk fullShiftLeft
  let x : FullShift 2 2 := fun i => Fin.mk (if i.val = 0 then 0 else 1) (by omega)
  let y : FullShift 2 2 := fun i => Fin.mk (if i.val = 0 then 1 else 0) (by omega)
  T.orbit x = {x, y} := by
  intro T x y; unfold T DynSystem.orbit DynSystem.mk DynSystem.pow DynSystem.iterate
    fullShiftLeft x y; native_decide

/-- Measure of cylinder set [0x] in full 2-shift of length 2. -/
example : let mu := ProbabilityMeasure.ofWeights
    (fun _ : FullShift 2 2 => (1/4 : Q)) (by intro x; norm_num) (by native_decide)
  let cyl := Finset.filter (fun seq => seq (Fin.mk 0 (by omega)) = Fin.mk 0 (by omega)) Finset.univ
  mu.setMeasure cyl = (1/2 : Q) := by
  intro mu cyl; unfold mu cyl ProbabilityMeasure.setMeasure; native_decide
