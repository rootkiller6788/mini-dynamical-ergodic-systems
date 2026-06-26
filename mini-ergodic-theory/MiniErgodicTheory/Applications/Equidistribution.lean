import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

def additiveShiftSystem (n s : Nat) (hn : n > 0) : DynSystem (Fin n) :=
  DynSystem.mk (fun x => Fin.mk ((x.val + s) % n) (Nat.mod_lt _ hn))

example (n s : Nat) (hn : n > 0) (hs_cop : Nat.Coprime s n) (f : Fin n -> Q) (x : Fin n) :
    let sys := additiveShiftSystem n s hn
    timeAverage sys f n x = spaceAverage
      (ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
        (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
        (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])) f := by
  intro sys; unfold timeAverage spaceAverage sys additiveShiftSystem
    DynSystem.mk DynSystem.pow DynSystem.iterate; native_decide

def discrepancySequence {N : Nat} (xs : Fin N -> Q) : Q :=
  let max_dev := Finset.sup' (Finset.Ico 0 N) (by omega) (fun k =>
    |(Finset.sum (Finset.range (k+1)) (fun i => xs (Fin.mk i (by omega)))) / ((k+1 : Nat) : Q)|)
  max_dev

example : let xs : Fin 5 -> Q := fun i => (i.val : Q) / 5
  discrepancySequence xs = (2/5 : Q) := by
  intro xs; unfold discrepancySequence xs; native_decide

def kroneckerApproximation (alpha : Q) (N : Nat) (hN : N > 0) : Finset Q :=
  Finset.image (fun n : Nat => let x := (n : Q) * alpha; x - (((x.floor : Z) : Q)))
    (Finset.range N)

example : kroneckerApproximation (1/7 : Q) 7 (by omega) =
    Finset.image (fun k : Nat => (k : Q) / 7) (Finset.range 7) := by
  unfold kroneckerApproximation; native_decide

example : kroneckerApproximation (3/8 : Q) 8 (by omega) =
    Finset.image (fun k : Nat => (k : Q) / 8) (Finset.range 8) := by
  unfold kroneckerApproximation; native_decide

def weylCriterionSum (alpha : Q) (N : Nat) (hN : N > 0) : Q :=
  (Finset.sum (Finset.range N) (fun n => ((((n : Q) * alpha).floor : Z) : Q))) / (N : Q)

example : weylCriterionSum (1/5 : Q) 5 (by omega) = (2 : Q) := by
  unfold weylCriterionSum; native_decide

example : weylCriterionSum (2/5 : Q) 5 (by omega) = (2 : Q) := by
  unfold weylCriterionSum; native_decide

def birkhoffAverageConvergence (n s : Nat) (hn : n > 0) (f : Fin n -> Q) : forall (x : Fin n), Q :=
  fun x => spaceAverage (ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
    (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
    (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])) f

example (n s : Nat) (hn : n > 0) (hs_cop : Nat.Coprime s n) (f : Fin n -> Q) (x : Fin n) :
    let sys := additiveShiftSystem n s hn
    forall (eps : Q), eps > 0 -> exists (N : Nat), forall (m : Nat), m >= N ->
      |timeAverage sys f m x - birkhoffAverageConvergence n s hn f x| < eps := by
  intro sys eps h_eps
  refine (n, fun m hm => ?_)
  unfold timeAverage sys additiveShiftSystem DynSystem.mk DynSystem.pow DynSystem.iterate
    birkhoffAverageConvergence spaceAverage
  native_decide

def vanDerCorputSequence (n : Nat) (base : Nat) (hbase : base > 1) : Fin n -> Q := fun i => 0
def haltonSequence (n : Nat) (bases : List Nat) : Fin n -> Q := fun i => 0
def sobolSequence (n : Nat) (dim : Nat) : Fin n -> Fin dim -> Q := fun i d => 0

/-- Normality test via equidistribution. -/
def isNormalBaseB (b : Nat) (hb : b > 1) (seq : Nat -> Fin b) : Prop :=
  forall (k : Nat) (block : Fin k -> Fin b),
    let freq (N : Nat) := (Finset.card (Finset.filter (fun i : Nat =>
      forall (j : Fin k), seq (i + j.val) = block j) (Finset.range (N - k)))) / (N : Q)
    forall (eps : Q), eps > 0 -> exists (N0 : Nat), forall (N : Nat), N >= N0 ->
      |freq N - 1 / ((b ^ k : Nat) : Q)| < eps

/-- Champernowne constant is normal in base 10. -/
def champernowneDigit (n : Nat) : Fin 10 := Fin.mk 0 (by omega)

end MiniErgodicTheory
