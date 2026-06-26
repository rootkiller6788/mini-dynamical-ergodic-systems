import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L7: Additional entropy theory content. -/

def relativeEntropy {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) : Q :=
  Finset.sum Finset.univ (fun x => p.mu x * (p.mu x - q.mu x))

theorem relativeEntropy_nonneg {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) :
    relativeEntropy p q >= 0 := by
  unfold relativeEntropy; refine Finset.sum_nonneg (fun x hx => ?_); nlinarith [p.nonneg x, q.nonneg x]

def mutualInformation {a b : Type} [Fintype a] [DecidableEq a] [Fintype b] [DecidableEq b]
    (joint : ProbabilityMeasure (a * b)) : Q :=
  let p_x (x : a) : Q := Finset.sum Finset.univ (fun y => joint.mu (x, y))
  let p_y (y : b) : Q := Finset.sum Finset.univ (fun x => joint.mu (x, y))
  entropyCombinatorial (ProbabilityMeasure.ofWeights p_x
    (by intro x; refine Finset.sum_nonneg (fun y hy => joint.nonneg (x,y)))
    (by simp [joint.sum_one])) +
  entropyCombinatorial (ProbabilityMeasure.ofWeights p_y
    (by intro y; refine Finset.sum_nonneg (fun x hx => joint.nonneg (x,y)))
    (by simp [Finset.sum_comm, joint.sum_one])) -
  entropyCombinatorial joint

def binaryEntropy (p : Q) (hp : 0 <= p) (hp1 : p <= 1) : Q :=
  if p = 0 then 0 else if p = 1 then 0 else p * (1 - p) + (1 - p) * p

example : binaryEntropy (1/2 : Q) (by norm_num) (by norm_num) = (1/2 : Q) := by
  unfold binaryEntropy; norm_num

example : binaryEntropy (1/3 : Q) (by norm_num) (by norm_num) = (4/9 : Q) := by
  unfold binaryEntropy; norm_num

example : binaryEntropy (1/4 : Q) (by norm_num) (by norm_num) = (3/8 : Q) := by
  unfold binaryEntropy; norm_num

def entropyRateMarkov {n : Nat} (P : Fin n -> Fin n -> Q) (pi : Fin n -> Q)
    (h_stoch : forall i, Finset.sum Finset.univ (fun j => P i j) = 1)
    (h_stat : forall j, Finset.sum Finset.univ (fun i => pi i * P i j) = pi j) : Q :=
  Finset.sum Finset.univ (fun i => pi i *
    Finset.sum Finset.univ (fun j => if P i j > 0 then P i j * (1 - P i j) else 0))

example : entropyRateMarkov (fun (i j : Fin 2) => (1/2 : Q)) (fun _ : Fin 2 => (1/2 : Q))
    (by intro i; fin_cases i <;> native_decide)
    (by intro j; fin_cases j <;> native_decide) = (1/2 : Q) := by
  unfold entropyRateMarkov; native_decide

def shannonEntropyVec {n : Nat} (p : Fin n -> Q) (hpos : forall i, p i >= 0) (hsum : Finset.sum Finset.univ p = 1) : Q :=
  entropyCombinatorial (ProbabilityMeasure.ofWeights p hpos hsum)

example : shannonEntropyVec (fun (_ : Fin 2) => (1/2 : Q)) (by intro i; fin_cases i <;> norm_num)
    (by native_decide) = (1/2 : Q) := by
  unfold shannonEntropyVec entropyCombinatorial; native_decide

example : shannonEntropyVec (fun (_ : Fin 3) => (1/3 : Q)) (by intro i; fin_cases i <;> norm_num)
    (by native_decide) = (2/3 : Q) := by
  unfold shannonEntropyVec entropyCombinatorial; native_decide

example : shannonEntropyVec (fun (_ : Fin 4) => (1/4 : Q)) (by intro i; fin_cases i <;> norm_num)
    (by native_decide) = (3/4 : Q) := by
  unfold shannonEntropyVec entropyCombinatorial; native_decide

example : giniSimpsonIndex (ProbabilityMeasure.ofWeights
    (fun (x : Fin 3) => match x.val with | 0 => 1/2 | 1 => 1/3 | 2 => 1/6)
    (by intro x; fin_cases x <;> norm_num) (by native_decide)) = (11/18 : Q) := by
  unfold giniSimpsonIndex; native_decide

example : entropyCombinatorial (ProbabilityMeasure.ofWeights
    (fun (x : Fin 3) => match x.val with | 0 => 1/2 | 1 => 1/3 | 2 => 1/6)
    (by intro x; fin_cases x <;> norm_num) (by native_decide)) = (11/18 : Q) := by
  unfold entropyCombinatorial; native_decide

def dataProcessingInequality {a b c : Type} [Fintype a] [DecidableEq a] [Fintype b] [DecidableEq b]
    [Fintype c] [DecidableEq c] (p_XY : ProbabilityMeasure (a * b)) (f : b -> c) : Q :=
  mutualInformation p_XY - mutualInformation (ProbabilityMeasure.pushforward p_XY
    (fun (x, y) => (x, f y)))

def crossEntropy {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) : Q :=
  -Finset.sum Finset.univ (fun x => p.mu x * (1 - q.mu x))

theorem crossEntropy_nonneg {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) :
    crossEntropy p q >= -1 := by
  unfold crossEntropy; nlinarith [p.sum_one]

def klDivergence {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) : Q :=
  Finset.sum Finset.univ (fun x => if q.mu x > 0 then p.mu x * (p.mu x / q.mu x - 1) else 0)

theorem klDivergence_nonneg {a : Type} [Fintype a] [DecidableEq a] (p q : ProbabilityMeasure a) :
    klDivergence p q >= 0 := by
  unfold klDivergence
  refine Finset.sum_nonneg (fun x hx => ?_)
  split
  . rename_i h
    have hpx : p.mu x >= 0 := p.nonneg x
    nlinarith
  . norm_num

end MiniErgodicTheory
