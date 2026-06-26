set_option checkBinderAnnotations false
namespace MiniErgodicTheory

/-! ## Probability Measures -/

structure ProbabilityMeasure (a : Type) [Fintype a] [DecidableEq a] where
  mu : a -> Q
  nonneg : forall x : a, mu x >= 0
  sum_one : (Finset.sum Finset.univ mu) = 1

def ProbabilityMeasure.setMeasure {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) (A : Finset a) : Q := Finset.sum A p.mu

def ProbabilityMeasure.dirac {a : Type} [Fintype a] [DecidableEq a]
    (x0 : a) : ProbabilityMeasure a where
  mu := fun x => if x = x0 then 1 else 0
  nonneg := by intro x; split <;> norm_num
  sum_one := by simp [Finset.sum_ite_eq, Finset.mem_univ]

def ProbabilityMeasure.ofWeights {a : Type} [Fintype a] [DecidableEq a]
    (weights : a -> Q) (hpos : forall x, weights x >= 0)
    (hsum : Finset.sum Finset.univ weights = 1) : ProbabilityMeasure a :=
  { mu := weights, nonneg := hpos, sum_one := hsum }

def ProbabilityMeasure.product {a b : Type} [Fintype a] [DecidableEq a]
    [Fintype b] [DecidableEq b] (p : ProbabilityMeasure a) (q : ProbabilityMeasure b) :
    ProbabilityMeasure (a * b) where
  mu := fun (x,y) => p.mu x * q.mu y
  nonneg := by intro (x,y); exact mul_nonneg (p.nonneg x) (q.nonneg y)
  sum_one := by
    calc
      Finset.sum Finset.univ (fun (x,y) => p.mu x * q.mu y)
          = Finset.sum Finset.univ (fun x => Finset.sum Finset.univ (fun y => p.mu x * q.mu y)) :=
        by rw [Finset.sum_product]
      _ = Finset.sum Finset.univ (fun x => p.mu x * Finset.sum Finset.univ (fun y => q.mu y)) :=
        by refine Finset.sum_congr rfl (fun x hx => ?_); simp [Finset.mul_sum]
      _ = (Finset.sum Finset.univ (fun x => p.mu x)) * (Finset.sum Finset.univ (fun y => q.mu y)) :=
        by simp [Finset.sum_mul]
      _ = 1 * 1 := by rw [p.sum_one, q.sum_one]
      _ = 1 := by norm_num

def ProbabilityMeasure.pushforward {a b : Type} [Fintype a] [DecidableEq a]
    [Fintype b] [DecidableEq b] (p : ProbabilityMeasure a) (f : a -> b) :
    ProbabilityMeasure b where
  mu := fun y => Finset.sum (Finset.filter (fun x => f x = y) Finset.univ) p.mu
  nonneg := by intro y; refine Finset.sum_nonneg (fun x hx => p.nonneg x)
  sum_one := by
    calc
      Finset.sum Finset.univ (fun y =>
        Finset.sum (Finset.filter (fun x => f x = y) Finset.univ) p.mu)
          = Finset.sum Finset.univ p.mu := by
        simpa using (Finset.sum_fiberwise Finset.univ f p.mu)
      _ = 1 := p.sum_one

@[simp] theorem ProbabilityMeasure.setMeasure_univ {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) : p.setMeasure Finset.univ = 1 :=
  by simp [ProbabilityMeasure.setMeasure, p.sum_one]

@[simp] theorem ProbabilityMeasure.setMeasure_empty {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) : p.setMeasure Finset.empty = 0 :=
  by simp [ProbabilityMeasure.setMeasure]

theorem ProbabilityMeasure.setMeasure_singleton {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) (x : a) : p.setMeasure {x} = p.mu x :=
  by simp [ProbabilityMeasure.setMeasure]

theorem ProbabilityMeasure.setMeasure_nonneg {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) (A : Finset a) : p.setMeasure A >= 0 :=
  Finset.sum_nonneg (fun x hx => p.nonneg x)

theorem ProbabilityMeasure.setMeasure_mono {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) {A B : Finset a} (h : A C= B) :
    p.setMeasure A <= p.setMeasure B :=
  Finset.sum_le_sum_of_subset h

theorem ProbabilityMeasure.setMeasure_union_of_disjoint {a : Type} [Fintype a] [DecidableEq a]
    (p : ProbabilityMeasure a) (A B : Finset a) (h : Finset.Disjoint A B) :
    p.setMeasure (A U+ B) = p.setMeasure A + p.setMeasure B := by
  unfold ProbabilityMeasure.setMeasure; rw [Finset.sum_union h]

/-! ## Dynamical Systems -/

structure DynSystem (a : Type) [Fintype a] [DecidableEq a] where
  T : a -> a

def DynSystem.iterate {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) : Nat -> (a -> a)
  | 0 => id
  | n+1 => sys.T o sys.iterate n

def DynSystem.pow {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (n : Nat) (x : a) : a := sys.iterate n x

@[simp] theorem DynSystem.pow_zero {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : sys.pow 0 x = x := rfl

@[simp] theorem DynSystem.pow_one {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : sys.pow 1 x = sys.T x := rfl

theorem DynSystem.pow_succ {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (n : Nat) (x : a) : sys.pow (n+1) x = sys.T (sys.pow n x) := rfl

theorem DynSystem.pow_add {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (m n : Nat) (x : a) :
    sys.pow m (sys.pow n x) = sys.pow (m + n) x := by
  induction m with
  | zero => simp
  | succ m ih => simp [DynSystem.pow_succ, ih, add_comm, add_left_comm, add_assoc]

theorem DynSystem.pow_mul {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (m n : Nat) (x : a) :
    sys.pow (m * n) x = (fun z => sys.pow n z)^[m] x := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [Nat.succ_mul, DynSystem.pow_add, Function.iterate_succ', Function.comp_apply, ih]

def DynSystem.orbit {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : Finset a :=
  Finset.image (fun n : Nat => sys.pow n x) (Finset.range (Fintype.card a + 1))

def DynSystem.orbitSize {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : Nat := (sys.orbit x).card

def DynSystem.isPeriodic {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : Prop :=
  exists n : Nat, n > 0 /\ sys.pow n x = x

def DynSystem.hasPeriod {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) (k : Nat) : Prop := sys.pow k x = x

theorem DynSystem.hasPeriod_dvd {a : Type} [Fintype a] [DecidableEq a]
    {sys : DynSystem a} {x : a} {m n : Nat}
    (hm : sys.hasPeriod x m) (h : m | n) : sys.hasPeriod x n := by
  rcases h with (k, hk); rw [hk, DynSystem.pow_mul, hm]; simp

theorem DynSystem.hasPeriod_add {a : Type} [Fintype a] [DecidableEq a]
    {sys : DynSystem a} {x : a} {m n : Nat}
    (hm : sys.hasPeriod x m) (hn : sys.hasPeriod x n) : sys.hasPeriod x (m + n) := by
  unfold DynSystem.hasPeriod at *; rw [DynSystem.pow_add, hm, hn]

theorem DynSystem.hasPeriod_mul {a : Type} [Fintype a] [DecidableEq a]
    {sys : DynSystem a} {x : a} {m k : Nat}
    (hm : sys.hasPeriod x m) : sys.hasPeriod x (m * k) := by
  rw [DynSystem.pow_mul, hm]
  induction k with
  | zero => simp [DynSystem.hasPeriod]
  | succ k ih => simp [Function.iterate_succ', ih]

def DynSystem.isPeriodicUpTo {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) (bound : Nat) : Bool :=
  Finset.any (Finset.range bound) (fun n => if h : n > 0 then sys.pow n x = x else false)

def DynSystem.isPeriodicDec {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (x : a) : Bool :=
  sys.isPeriodicUpTo x (Fintype.card a + 1)

/-! ## Measure-Preserving Systems -/

structure MPDS (a : Type) [Fintype a] [DecidableEq a] extends DynSystem a where
  prob : ProbabilityMeasure a
  measure_preserving : forall A : Finset a,
    prob.setMeasure A = prob.setMeasure (Finset.filter (fun x => T x ∈ A) Finset.univ)

theorem MPDS.measure_preserving_pointwise {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (x : a) : sys.prob.mu x =
    Finset.sum (Finset.filter (fun y => sys.T y = x) Finset.univ) sys.prob.mu := by
  have h := sys.measure_preserving {x}
  simp [ProbabilityMeasure.setMeasure] at h
  have h_eq : Finset.filter (fun y => sys.T y in ({x} : Finset a)) Finset.univ =
              Finset.filter (fun y => sys.T y = x) Finset.univ := by
    ext y; simp
  rw [h_eq] at h; exact h.symm

theorem MPDS.iterate_measure_preserving {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (n : Nat) : forall A : Finset a,
    sys.prob.setMeasure A =
    sys.prob.setMeasure (Finset.filter (fun x => sys.pow n x ∈ A) Finset.univ) := by
  induction n with
  | zero => intro A; simp
  | succ n ih =>
    intro A
    calc
      sys.prob.setMeasure A =
          sys.prob.setMeasure (Finset.filter (fun y => sys.T y ∈ A) Finset.univ) :=
        sys.measure_preserving A
      _ = sys.prob.setMeasure (Finset.filter (fun x => sys.pow n x ∈ filter (fun y => sys.T y ∈ A) Finset.univ) Finset.univ) := by rw [ih]
      _ = sys.prob.setMeasure (Finset.filter (fun x => sys.pow (n+1) x ∈ A) Finset.univ) := by
        refine congrArg sys.prob.setMeasure ?_
        ext x; simp [DynSystem.pow_succ, Finset.mem_filter, and_comm, and_assoc]

def MPDS.mk' {a : Type} [Fintype a] [DecidableEq a]
    (T : a -> a) (p : ProbabilityMeasure a)
    (hpres : forall A : Finset a,
      p.setMeasure A = p.setMeasure (Finset.filter (fun x => T x ∈ A) Finset.univ)) :
    MPDS a := { T := T, prob := p, measure_preserving := hpres }

/-! ## Invariant Sets and Functions -/

def MPDS.isInvariantSet {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A : Finset a) : Prop :=
  Finset.filter (fun x => sys.T x ∈ A) Finset.univ = A

def MPDS.isInvariantFunction {a b : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (f : a -> b) : Prop := forall x : a, f (sys.T x) = f x

def MPDS.isInvariantSetDec {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A : Finset a) : Bool :=
  Finset.filter (fun x => sys.T x ∈ A) Finset.univ == A

theorem MPDS.empty_invariant {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : sys.isInvariantSet Finset.empty := by
  unfold MPDS.isInvariantSet
  apply Finset.eq_empty_of_not_mem
  intro x hx
  rcases Finset.mem_filter.mp hx with (hx_univ, hx_T_empty)
  exact Finset.not_mem_empty (sys.T x) hx_T_empty

theorem MPDS.univ_invariant {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : sys.isInvariantSet Finset.univ := by
  unfold MPDS.isInvariantSet; simp

theorem MPDS.compl_invariant {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A : Finset a) (hA : sys.isInvariantSet A) :
    sys.isInvariantSet (Finset.univ \ A) := by
  unfold MPDS.isInvariantSet at hA
  unfold MPDS.isInvariantSet
  ext x; simp
  rw [← hA]; simp [Finset.mem_filter]

theorem MPDS.union_invariant {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A B : Finset a)
    (hA : sys.isInvariantSet A) (hB : sys.isInvariantSet B) :
    sys.isInvariantSet (A U+ B) := by
  unfold MPDS.isInvariantSet at hA hB
  unfold MPDS.isInvariantSet
  ext x; simp
  rw [← hA, ← hB]; simp [Finset.mem_filter]

theorem MPDS.inter_invariant {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A B : Finset a)
    (hA : sys.isInvariantSet A) (hB : sys.isInvariantSet B) :
    sys.isInvariantSet (A cap B) := by
  unfold MPDS.isInvariantSet at hA hB
  unfold MPDS.isInvariantSet
  ext x; simp
  rw [← hA, ← hB]; simp [Finset.mem_filter]

/-! ## Ergodicity and Mixing (Definitions) -/

def MPDS.isErgodic {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : Prop :=
  forall A : Finset a, sys.isInvariantSet A ->
    sys.prob.setMeasure A = 0 \/ sys.prob.setMeasure A = 1

def MPDS.isMixing {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : Prop :=
  forall (A B : Finset a) (eps : Q), eps > 0 ->
    exists N : Nat, forall (n : Nat), n >= N ->
      |sys.prob.setMeasure
        (Finset.filter (fun x => sys.pow n x ∈ A) Finset.univ cap B) -
       sys.prob.setMeasure A * sys.prob.setMeasure B| < eps

def MPDS.isWeakMixing {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : Prop :=
  forall (A B : Finset a) (eps : Q), eps > 0 ->
    exists N : Nat, forall (n : Nat), n >= N ->
      (Finset.sum (Finset.range n) (fun k =>
        |sys.prob.setMeasure
          (Finset.filter (fun x => sys.pow k x ∈ A) Finset.univ cap B) -
         sys.prob.setMeasure A * sys.prob.setMeasure B|)) / (n : Q) < eps

def MPDS.isErgodicDec {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) : Bool :=
  let subsets := Finset.powerset Finset.univ
  Finset.all subsets (fun A =>
    -sys.isInvariantSetDec A ||
    (sys.prob.setMeasure A == 0 || sys.prob.setMeasure A == 1))

/-! ## Time and Space Averages -/

def timeAverage {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (f : a -> Q) (n : Nat) (x : a) : Q :=
  if h : n = 0 then 0
  else (Finset.sum (Finset.range n) (fun k => f (sys.pow k x))) / (n : Q)

def spaceAverage {a : Type} [Fintype a] [DecidableEq a]
    (mu : ProbabilityMeasure a) (f : a -> Q) : Q :=
  Finset.sum Finset.univ (fun x => mu.mu x * f x)

theorem timeAverage_one {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (f : a -> Q) (x : a) : timeAverage sys f 1 x = f x := by
  unfold timeAverage; simp

theorem spaceAverage_const {a : Type} [Fintype a] [DecidableEq a]
    (mu : ProbabilityMeasure a) (c : Q) : spaceAverage mu (fun _ => c) = c := by
  unfold spaceAverage; simp [mu.sum_one]

theorem spaceAverage_nonneg_of_nonneg {a : Type} [Fintype a] [DecidableEq a]
    (mu : ProbabilityMeasure a) (f : a -> Q) (hf : forall x, f x >= 0) :
    spaceAverage mu f >= 0 :=
  Finset.sum_nonneg (fun x hx => mul_nonneg (mu.nonneg x) (hf x))

theorem spaceAverage_between {a : Type} [Fintype a] [DecidableEq a]
    (mu : ProbabilityMeasure a) (f : a -> Q) (L U : Q)
    (hL : forall x, L <= f x) (hU : forall x, f x <= U) :
    L <= spaceAverage mu f /\ spaceAverage mu f <= U := by
  unfold spaceAverage
  have hLsum : L <= Finset.sum Finset.univ (fun x => mu.mu x * f x) := by
    calc
      L = L * 1 := by ring
      _ = L * (Finset.sum Finset.univ mu.mu) := by rw [mu.sum_one]
      _ = Finset.sum Finset.univ (fun x => L * mu.mu x) := by simp [Finset.mul_sum]
      _ <= Finset.sum Finset.univ (fun x => f x * mu.mu x) :=
        Finset.sum_le_sum (fun x hx => mul_le_mul_of_nonneg_right (hL x) (mu.nonneg x))
      _ = Finset.sum Finset.univ (fun x => mu.mu x * f x) := by
        refine Finset.sum_congr rfl (fun x hx => ?_); ring
  have hUsum : Finset.sum Finset.univ (fun x => mu.mu x * f x) <= U := by
    calc
      Finset.sum Finset.univ (fun x => mu.mu x * f x) <=
      Finset.sum Finset.univ (fun x => mu.mu x * U) :=
        Finset.sum_le_sum (fun x hx => mul_le_mul_of_nonneg_left (hU x) (mu.nonneg x))
      _ = (Finset.sum Finset.univ mu.mu) * U := by simp [Finset.sum_mul]
      _ = 1 * U := by rw [mu.sum_one]
      _ = U := by ring
  exact (hLsum, hUsum)

theorem timeAverage_between {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (f : a -> Q) (L U : Q) (n : Nat) (x : a)
    (hnpos : n > 0) (hL : forall y, L <= f y) (hU : forall y, f y <= U) :
    L <= timeAverage sys f n x /\ timeAverage sys f n x <= U := by
  unfold timeAverage
  have hnpos_q : (n : Q) > 0 := by exact_mod_cast hnpos
  simp [hnpos.ne.symm]
  have hsumL : (n : Q) * L <= Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) := by
    calc
      (n : Q) * L = Finset.sum (Finset.range n) (fun _ => L) := by simp
      _ <= Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) :=
        Finset.sum_le_sum (fun k hk => hL (sys.pow k x))
  have hsumU : Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) <= (n : Q) * U := by
    calc
      Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) <=
      Finset.sum (Finset.range n) (fun _ => U) :=
        Finset.sum_le_sum (fun k hk => hU (sys.pow k x))
      _ = (n : Q) * U := by simp
  constructor
  . have hLdiv : ((n : Q) * L) / (n : Q) <=
        Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) / (n : Q) :=
      (div_le_div_right hnpos_q).mpr hsumL
    have hLsimp : ((n : Q) * L) / (n : Q) = L := by field_simp [ne_of_gt hnpos_q]
    rw [hLsimp] at hLdiv; exact hLdiv
  . have hUdiv : Finset.sum (Finset.range n) (fun k => f (sys.pow k x)) / (n : Q) <=
        ((n : Q) * U) / (n : Q) := (div_le_div_right hnpos_q).mpr hsumU
    have hUsimp : ((n : Q) * U) / (n : Q) = U := by field_simp [ne_of_gt hnpos_q]
    rw [hUsimp] at hUdiv; exact hUdiv

/-! ## Koopman Operator -/

def KoopmanOperator {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (f : a -> Q) : a -> Q := fun x => f (sys.T x)

theorem KoopmanOperator.iterate_eq {a : Type} [Fintype a] [DecidableEq a]
    (sys : DynSystem a) (f : a -> Q) (n : Nat) (x : a) :
    (KoopmanOperator sys)^[n] f x = f (sys.pow n x) := by
  induction n generalizing x with
  | zero => simp [KoopmanOperator]
  | succ n ih =>
    simp [KoopmanOperator, Function.iterate_succ', DynSystem.pow_succ, ih]

/-! ## Computable Checks -/

def checkMeasurePreserving {n : Nat} (T : Fin n -> Fin n)
    (mu : Fin n -> Q) : Bool :=
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    Finset.sum A mu ==
    Finset.sum (Finset.filter (fun x => T x ∈ A) Finset.univ) mu)

def checkErgodic {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) : Bool :=
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    let isInv := Finset.filter (fun x => T x ∈ A) Finset.univ == A
    let measA := Finset.sum A mu
    -(isInv && (measA /= 0 && measA /= 1)))

def checkMixing {n : Nat} (T : Fin n -> Fin n) (mu : Fin n -> Q) : Bool :=
  let N := n * n + 1
  let subsets := Finset.powerset (Finset.univ : Finset (Fin n))
  Finset.all subsets (fun A =>
    Finset.all subsets (fun B =>
      let target := Finset.sum A mu * Finset.sum B mu
      Finset.any (Finset.range N) (fun k =>
        let actual := Finset.sum
          (Finset.filter (fun x => (fun i => T^[k] i) x ∈ A)
            Finset.univ cap B) mu
        |actual - target| < (1 : Q)/2
      )))

/-! ## Finite Verification Examples -/

example : checkMeasurePreserving (fun (x : Fin 3) =>
    if h : x.val + 1 < 3 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ => (1/3 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 4) =>
    if h : x.val + 1 < 4 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
    (fun _ => (1/4 : Q)) = true := by native_decide

example : checkMeasurePreserving (fun (x : Fin 5) => x)
    (fun _ => (1/5 : Q)) = true := by native_decide

example : checkErgodic (fun (x : Fin 2) => x)
    (fun _ => (1/2 : Q)) = false := by native_decide

example : spaceAverage (ProbabilityMeasure.dirac (0 : Fin 3))
    (fun x => if x = 0 then (1 : Q) else 0) = 1 := by
  unfold spaceAverage ProbabilityMeasure.dirac
  native_decide

example : timeAverage (DynSystem.mk (fun (x : Fin 5) => x))
    (fun x => (x.val : Q)) 10 (Fin.mk 2 (by omega)) = (2 : Q) := by
  unfold timeAverage DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

end MiniErgodicTheory


/-- Verify measure preservation for identity on Fin n. -/
example : checkMeasurePreserving (fun (x : Fin 10) => x)
    (fun _ => (1/10 : Q)) = true := by native_decide

/-- Verify measure preservation for transposition on Fin 4. -/
example : checkMeasurePreserving (fun (x : Fin 4) =>
    if x.val = 0 then Fin.mk 1 (by omega)
    else if x.val = 1 then Fin.mk 0 (by omega)
    else x) (fun _ => (1/4 : Q)) = true := by native_decide

/-- Verify that a non-bijective map does NOT preserve uniform measure. -/
example : checkMeasurePreserving (fun (x : Fin 5) => Fin.mk 0 (by omega))
    (fun _ => (1/5 : Q)) = false := by native_decide

/-- Space average of position on Fin 7 with uniform measure is 3. -/
example : spaceAverage (ProbabilityMeasure.ofWeights
    (fun _ : Fin 7 => (1/7 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 7 => (x.val : Q)) = (3 : Q) := by
  unfold spaceAverage; native_decide

/-- Space average of position squared on Fin 5 is 6. -/
example : spaceAverage (ProbabilityMeasure.ofWeights
    (fun _ : Fin 5 => (1/5 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 5 => ((x.val : Q) ^ 2)) = (6 : Q) := by
  unfold spaceAverage; native_decide

/-- Space average of position squared on Fin 6 is 55/6. -/
example : spaceAverage (ProbabilityMeasure.ofWeights
    (fun _ : Fin 6 => (1/6 : Q)) (by intro x; norm_num) (by native_decide))
    (fun x : Fin 6 => ((x.val : Q) ^ 2)) = (55/6 : Q) := by
  unfold spaceAverage; native_decide

/-- Time average for n=0 is always 0. -/
example (sys : DynSystem (Fin 3)) (f : Fin 3 -> Q) (x : Fin 3) :
    timeAverage sys f 0 x = 0 := by
  unfold timeAverage; simp

/-- Space average with Dirac measure equals function value at the point. -/
example (x0 : Fin 5) (f : Fin 5 -> Q) : spaceAverage
    (ProbabilityMeasure.dirac x0) f = f x0 := by
  unfold spaceAverage ProbabilityMeasure.dirac
  simp [Finset.sum_ite_eq, Finset.mem_univ]

/-- Product measure of Dirac at x0 and Dirac at y0 is Dirac at (x0,y0). -/
example (x0 : Fin 3) (y0 : Fin 2) :
    (ProbabilityMeasure.product (ProbabilityMeasure.dirac x0)
      (ProbabilityMeasure.dirac y0)).mu (x0, y0) = 1 := by
  unfold ProbabilityMeasure.product ProbabilityMeasure.dirac; simp

/-- Pushforward of Dirac by T is Dirac at T(x0). -/
example (x0 : Fin 5) (T : Fin 5 -> Fin 5) :
    (ProbabilityMeasure.pushforward (ProbabilityMeasure.dirac x0) T).mu (T x0) = 1 := by
  unfold ProbabilityMeasure.pushforward ProbabilityMeasure.dirac
  simp [Finset.sum_ite_eq, Finset.mem_univ]


/-- pushforward of uniform measure by bijection is uniform. -/
example : let f : Fin 5 -> Fin 5 := fun x =>
    if h : x.val + 1 < 5 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)
  let mu := ProbabilityMeasure.ofWeights (fun _ : Fin 5 => (1/5 : Q))
    (by intro x; norm_num) (by native_decide)
  let nu := ProbabilityMeasure.pushforward mu f
  forall (x : Fin 5), nu.mu x = (1/5 : Q) := by
  intro f mu nu x
  unfold nu ProbabilityMeasure.pushforward mu
  native_decide

/-- The product measure of two uniform measures is uniform. -/
example : let mu2 := ProbabilityMeasure.ofWeights (fun _ : Fin 2 => (1/2 : Q))
    (by intro x; norm_num) (by native_decide)
  let mu3 := ProbabilityMeasure.ofWeights (fun _ : Fin 3 => (1/3 : Q))
    (by intro x; norm_num) (by native_decide)
  let mu_prod := ProbabilityMeasure.product mu2 mu3
  forall (x : Fin 2) (y : Fin 3), mu_prod.mu (x, y) = (1/6 : Q) := by
  intro mu2 mu3 mu_prod x y
  unfold mu_prod ProbabilityMeasure.product mu2 mu3
  native_decide

/-- Set measure of a subset for uniform measure equals |A|/n. -/
example (n : Nat) (hn : n > 0) (A : Finset (Fin n)) :
    let mu := ProbabilityMeasure.ofWeights (fun _ : Fin n => 1 / (n : Q))
      (by intro x; refine div_nonneg (by norm_num) (Nat.cast_nonneg _))
      (by simp [Finset.sum_const_nsmul]; field_simp [ne_of_gt hn])
    mu.setMeasure A = (A.card : Q) / (n : Q) := by
  intro mu
  unfold ProbabilityMeasure.setMeasure mu
  simp [Finset.sum_const_nsmul]

/-- Invariant set means T^{-1}(A) = A. This implies T maps A into A. -/
example (sys : MPDS (Fin 5)) (A : Finset (Fin 5)) (h_inv : sys.isInvariantSet A) (x : Fin 5) (hx : x ∈ A) :
    sys.T x ∈ A := by
  unfold MPDS.isInvariantSet at h_inv
  have h_pre : x ∈ filter (fun y => sys.T y ∈ A) Finset.univ :=
    Finset.mem_filter.mpr (Finset.mem_univ x, hx)
  rw [h_inv] at h_pre
  exact h_pre

/-- If A is invariant, T(x) in A iff x ∈ A. -/
theorem invariant_iff_T_mem {a : Type} [Fintype a] [DecidableEq a]
    (sys : MPDS a) (A : Finset a) (h_inv : sys.isInvariantSet A) (x : a) :
    (sys.T x ∈ A) <-> (x in A) := by
  unfold MPDS.isInvariantSet at h_inv
  constructor
  . intro hTx
    have hx_filter : x ∈ filter (fun y => sys.T y ∈ A) Finset.univ :=
      Finset.mem_filter.mpr (Finset.mem_univ x, hTx)
    rw [h_inv] at hx_filter; exact hx_filter
  . intro hx
    have hx_filter : x ∈ filter (fun y => sys.T y ∈ A) Finset.univ := by
      rw [h_inv]; exact hx
    rcases Finset.mem_filter.mp hx_filter with (_, hTx)
    exact hTx

/-- The union of all invariant sets forms an ergodic decomposition. -/
def ergodicDecomposition (sys : MPDS (Fin 5)) : Finset (Finset (Fin 5)) :=
  Finset.filter (fun A => sys.isInvariantSetDec A) (Finset.powerset Finset.univ)


/-- Measure of the whole space is 1. -/
example (mu : ProbabilityMeasure (Fin 5)) : mu.setMeasure Finset.univ = 1 :=
  ProbabilityMeasure.setMeasure_univ mu

/-- Measure of empty set is 0. -/
example (mu : ProbabilityMeasure (Fin 5)) : mu.setMeasure Finset.empty = 0 :=
  ProbabilityMeasure.setMeasure_empty mu

/-- Nonnegativity of measure. -/
example (mu : ProbabilityMeasure (Fin 5)) (A : Finset (Fin 5)) : mu.setMeasure A >= 0 :=
  ProbabilityMeasure.setMeasure_nonneg mu A

/-- Monotonicity of measure. -/
example (mu : ProbabilityMeasure (Fin 5)) (A B : Finset (Fin 5)) (h : A C= B) :
    mu.setMeasure A <= mu.setMeasure B :=
  ProbabilityMeasure.setMeasure_mono mu h

/-- Additivity for disjoint sets. -/
example (mu : ProbabilityMeasure (Fin 5)) (A B : Finset (Fin 5)) (h : Finset.Disjoint A B) :
    mu.setMeasure (A U+ B) = mu.setMeasure A + mu.setMeasure B :=
  ProbabilityMeasure.setMeasure_union_of_disjoint mu A B h

/-- Measure of singleton equals point mass. -/
example (mu : ProbabilityMeasure (Fin 5)) (x : Fin 5) : mu.setMeasure {x} = mu.mu x :=
  ProbabilityMeasure.setMeasure_singleton mu x
