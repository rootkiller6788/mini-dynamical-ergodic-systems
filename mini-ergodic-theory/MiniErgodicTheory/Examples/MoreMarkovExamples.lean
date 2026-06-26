import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

/-! L6: Additional Markov chain examples and computations. -/

def transitionPower3 (n : Nat) : Fin 3 -> Fin 3 -> Q :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => 1/3 | 0, 1 => 1/3 | 0, 2 => 1/3
    | 1, 0 => 1/2 | 1, 1 => 1/4 | 1, 2 => 1/4
    | 2, 0 => 1/6 | 2, 1 => 1/3 | 2, 2 => 1/2
    | _, _ => 0

example : isStochastic transitionPower3 := by
  unfold isStochastic transitionPower3; intro i; fin_cases i <;> native_decide

def twoStateStationaryExplicit (p q : Q) : Fin 2 -> Q :=
  fun i => if i.val = 0 then q / (p + q) else p / (p + q)

example (p q : Q) (hsum : p + q > 0) : Finset.sum Finset.univ (twoStateStationaryExplicit p q) = 1 := by
  unfold twoStateStationaryExplicit; field_simp [ne_of_gt hsum]; ring

def isStationaryExplicit {n : Nat} (P : Fin n -> Fin n -> Q) (pi : Fin n -> Q) : Prop :=
  forall j, Finset.sum Finset.univ (fun i => pi i * P i j) = pi j

example (p q : Q) (hsum : p + q /= 0) : isStationaryExplicit
    (fun i j => match i.val, j.val with | 0,0 => 1-p | 0,1 => p | 1,0 => q | 1,1 => 1-q | _, _ => 0)
    (twoStateStationaryExplicit p q) := by
  unfold isStationaryExplicit twoStateStationaryExplicit
  intro j; fin_cases j <;> field_simp [hsum] <;> ring

def markovChainStep {n : Nat} (P : Fin n -> Fin n -> Q) (dist : Fin n -> Q) : Fin n -> Q :=
  fun j => Finset.sum Finset.univ (fun i => dist i * P i j)

example : let P : Fin 2 -> Fin 2 -> Q := fun i j => (1/2 : Q)
  let dist : Fin 2 -> Q := fun i => if i.val = 0 then 1 else 0
  markovChainStep P dist (Fin.mk 0 (by omega)) = (1/2 : Q) := by
  intro P dist; unfold markovChainStep P dist; native_decide

def markovChainKSteps {n : Nat} (P : Fin n -> Fin n -> Q) (dist : Fin n -> Q) : Nat -> Fin n -> Q
  | 0 => dist
  | k+1 => markovChainStep P (markovChainKSteps P dist k)

example : let P : Fin 2 -> Fin 2 -> Q := fun i j => (1/2 : Q)
  let dist : Fin 2 -> Q := fun i => if i.val = 0 then 1 else 0
  markovChainKSteps P dist 2 (Fin.mk 0 (by omega)) = (1/2 : Q) := by
  intro P dist; unfold markovChainKSteps markovChainStep P dist; native_decide

def totalVariationDist {n : Nat} (p q : Fin n -> Q) : Q :=
  (1/2 : Q) * Finset.sum Finset.univ (fun i => |p i - q i|)

example : let p : Fin 2 -> Q := fun _ => (1/2 : Q)
  let q : Fin 2 -> Q := fun i => if i.val = 0 then 1 else 0
  totalVariationDist p q = (1/2 : Q) := by
  intro p q; unfold totalVariationDist p q; native_decide

def mixingTimeMarkov {n : Nat} (P : Fin n -> Fin n -> Q) (pi : Fin n -> Q) (eps : Q) : Nat :=
  let N := n * n + 1
  let rec find (k : Nat) : Nat :=
    if k > N then N
    else
      let max_tv := Finset.sup' Finset.univ (Finset.univ_nonempty) (fun i =>
        let dist_i_i := fun j => if j = i then 1 else 0
        totalVariationDist (markovChainKSteps P dist_i_i k) pi)
      if max_tv < eps then k else find (k+1)
  find 1

example : let P : Fin 2 -> Fin 2 -> Q := fun _ _ => (1/2 : Q)
  let pi : Fin 2 -> Q := fun _ => (1/2 : Q)
  mixingTimeMarkov P pi (1/10 : Q) = 1 := by
  intro P pi; unfold mixingTimeMarkov; native_decide

/-- Perron-Frobenius: For a primitive stochastic matrix, M^k -> pi (the stationary distribution). -/
def isPrimitive {n : Nat} (P : Fin n -> Fin n -> Q) : Prop :=
  exists (k : Nat), k > 0 /\ forall (i j : Fin n), markovChainKSteps P
    (fun i' => if i' = i then 1 else 0) k j > 0

/-- Lazy random walk: with probability 1/2 stay, 1/2 move to neighbor. -/
def lazyRandomWalk (n : Nat) (hn : n > 0) : Fin n -> Fin n -> Q :=
  fun i j =>
    if i = j then (1/2 : Q)
    else if (i.val + 1) % n = j.val then (1/4 : Q)
    else if (j.val + 1) % n = i.val then (1/4 : Q)
    else 0

example : isStochastic (lazyRandomWalk 5 (by omega)) := by
  unfold isStochastic lazyRandomWalk; intro i; native_decide

example : let P := lazyRandomWalk 5 (by omega)
  let pi : Fin 5 -> Q := fun _ => (1/5 : Q)
  isStationaryExplicit P pi := by
  intro P pi; unfold isStationaryExplicit P pi lazyRandomWalk; intro j; native_decide

/-- Metropolis-Hastings algorithm: proposal Q, target distribution pi. -/
def metropolisHastings {n : Nat} (pi : Fin n -> Q) (Q : Fin n -> Fin n -> Q)
    (hpi_pos : forall i, pi i > 0) : Fin n -> Fin n -> Q :=
  fun i j =>
    if i = j then 1 - Finset.sum Finset.univ (fun k =>
      if k = i then 0 else Q i k * min 1 (pi k * Q k i / (pi i * Q i k)))
    else Q i j * min 1 (pi j * Q j i / (pi i * Q i j))

def min (a b : Q) : Q := if a <= b then a else b

/-- Coupling method: two copies of Markov chain meet. -/
def couplingTime {n : Nat} (P : Fin n -> Fin n -> Q) : Nat :=
  let N := n * n
  let rec find (k : Nat) : Nat :=
    if k > N then N else
      let max_prob := Finset.sup' Finset.univ (Finset.univ_nonempty) (fun i =>
        Finset.sup' Finset.univ (Finset.univ_nonempty) (fun j =>
          if i = j then (1 : Q) else
          Finset.sum Finset.univ (fun l => P i l * P j l)))
      if max_prob >= (1/2 : Q) then k else find (k+1)
  find 1

end MiniErgodicTheory
