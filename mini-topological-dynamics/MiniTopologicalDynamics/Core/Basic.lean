/-
# MiniTopologicalDynamics: Core Definitions
Self-contained: no external dependencies, pure ASCII.
-/
namespace MiniTopologicalDynamics
set_option maxHeartbeats 400000

def Set (alpha : Type u) : Type u := alpha -> Prop
def Set.mem (a : alpha) (A : Set alpha) : Prop := A a
def Set.univ : Set alpha := fun _ => True
def Set.empty : Set alpha := fun _ => False
def Set.compl (A : Set alpha) : Set alpha := fun a => Not (Set.mem a A)
def Set.union (A B : Set alpha) : Set alpha := fun a => Or (Set.mem a A) (Set.mem a B)
def Set.inter (A B : Set alpha) : Set alpha := fun a => And (Set.mem a A) (Set.mem a B)
def Set.Subset (A B : Set alpha) : Prop := forall a, Set.mem a A -> Set.mem a B
def Set.preimage {alpha beta : Type u} (f : alpha -> beta) (B : Set beta) : Set alpha := fun a => B (f a)
def Set.image {alpha beta : Type u} (f : alpha -> beta) (A : Set alpha) : Set beta := fun b => exists a, And (Set.mem a A) (f a = b)
def Set.singleton (a : alpha) : Set alpha := fun x => x = a
def Set.Nonempty (A : Set alpha) : Prop := exists a, Set.mem a A

theorem Set.mem_univ (a : alpha) : Set.mem a Set.univ := trivial
theorem Set.not_mem_empty (a : alpha) : Not (Set.mem a Set.empty) := id
theorem Set.subset_univ (A : Set alpha) : Set.Subset A Set.univ := fun a _ => trivial
theorem Set.empty_subset (A : Set alpha) : Set.Subset Set.empty A := fun a ha => False.elim ha
theorem Set.inter_univ (A : Set alpha) : Set.inter A Set.univ = A := by
  funext a; apply propext; constructor
  · intro h; cases h; case intro h1 h2 => exact h1
  · intro h; exact And.intro h trivial
theorem Set.univ_inter (A : Set alpha) : Set.inter Set.univ A = A := by
  funext a; apply propext; constructor
  · intro h; cases h; case intro h1 h2 => exact h2
  · intro h; exact And.intro trivial h

class TopologicalSpace (X : Type u) where
  IsOpen : (X -> Prop) -> Prop
  isOpen_univ : IsOpen (fun _ : X => True)
  isOpen_inter : forall (U V : X -> Prop), IsOpen U -> IsOpen V -> IsOpen (fun x => U x and V x)

export TopologicalSpace (IsOpen)

def IsClosed {X : Type u} [TopologicalSpace X] (F : Set X) : Prop := IsOpen (Set.compl F)
theorem isClosed_univ {X : Type u} [TopologicalSpace X] : IsClosed (Set.univ : Set X) := by
  have h : Set.compl (Set.univ : Set X) = (Set.empty : Set X) := by
    funext a; apply propext; constructor
    · intro hc; dsimp [Set.compl, Set.mem] at hc; exfalso; exact hc trivial
    · intro he; exfalso; exact he
  rw [IsClosed, h]; exact isOpen_empty
theorem isClosed_empty {X : Type u} [TopologicalSpace X] : IsClosed (Set.empty : Set X) := by
  have h : Set.compl (Set.empty : Set X) = (Set.univ : Set X) := by
    funext a; apply propext; constructor
    · intro hc; trivial
    · intro htriv; intro hmem; exact hmem
  rw [IsClosed, h]; exact isOpen_univ

def Continuous {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (f : X -> Y) : Prop :=
  forall U : Set Y, IsOpen U -> IsOpen (Set.preimage f U)

theorem continuous_id {X : Type u} [TopologicalSpace X] : Continuous (fun (x : X) => x) := by
  intro U hU; have hpre : Set.preimage (fun (x : X) => x) U = U := by
    funext x; apply propext; dsimp [Set.preimage]; rfl
  rw [hpre]; exact hU

theorem continuous_comp {X Y Z : Type u} [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]
    {f : X -> Y} {g : Y -> Z} (hf : Continuous f) (hg : Continuous g) : Continuous (fun x => g (f x)) := by
  intro U hU; have h1 := hg U hU; have h2 := hf (Set.preimage g U) h1
  have hpre : Set.preimage (fun x => g (f x)) U = Set.preimage f (Set.preimage g U) := by
    funext x; apply propext; dsimp [Set.preimage]; rfl
  rw [hpre]; exact h2

theorem continuous_const {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (y : Y) :
    Continuous (fun (_ : X) => y) := by
  intro U hU; by_cases hy : Set.mem y U
  { have hpre : Set.preimage (fun (_ : X) => y) U = Set.univ := by
      funext x; apply propext; constructor
      { intro h; trivial }
      { intro h; exact hy }
    rw [hpre]; exact isOpen_univ }
  { have hpre : Set.preimage (fun (_ : X) => y) U = Set.empty := by
      funext x; apply propext; constructor
      { intro h; exact h }
      { intro h; exfalso; exact h }
    rw [hpre]; exact isOpen_empty }

structure Homeomorphism (X Y : Type u) [TopologicalSpace X] [TopologicalSpace Y] where
  toFun : X -> Y; invFun : Y -> X
  left_inv : forall x, invFun (toFun x) = x; right_inv : forall y, toFun (invFun y) = y
  continuous_toFun : Continuous toFun; continuous_invFun : Continuous invFun

def Homeomorphism.id (X : Type u) [TopologicalSpace X] : Homeomorphism X X where
  toFun := fun x => x; invFun := fun x => x
  left_inv := fun _ => rfl; right_inv := fun _ => rfl
  continuous_toFun := continuous_id; continuous_invFun := continuous_id

structure TopDynamicalSystem (X : Type u) [TopologicalSpace X] where
  T : X -> X; continuous_T : Continuous T

def TopDynamicalSystem.iterate (tds : TopDynamicalSystem X) : Nat -> X -> X
  | 0, x => x; | n+1, x => tds.T (iterate tds n x)

theorem TopDynamicalSystem.iterate_continuous (tds : TopDynamicalSystem X) (n : Nat) : Continuous (tds.iterate n) := by
  induction n with | zero => exact continuous_id
  | succ k ih => have hcomp : tds.iterate (k+1) = fun x => tds.T (tds.iterate k x) := by funext x; rfl
    rw [hcomp]; apply continuous_comp ih tds.continuous_T

theorem TopDynamicalSystem.iterate_add (tds : TopDynamicalSystem X) (m n : Nat) (x : X) :
    tds.iterate (m + n) x = tds.iterate m (tds.iterate n x) := by
  induction m with | zero => rfl | succ k ih => simp [Nat.add_succ, ih, tds.iterate]

theorem TopDynamicalSystem.iterate_mul (tds : TopDynamicalSystem X) (m n : Nat) (x : X) :
    tds.iterate (m * n) x = (TopDynamicalSystem.mk (tds.iterate m) (tds.iterate_continuous m)).iterate n x := by
  induction n with | zero => rfl | succ k ih => rw [Nat.mul_succ, tds.iterate_add, ih]; rfl

theorem TopDynamicalSystem.iterate_commute (tds : TopDynamicalSystem X) (m n : Nat) (x : X) :
    tds.iterate m (tds.iterate n x) = tds.iterate n (tds.iterate m x) := by
  rw [<- tds.iterate_add, Nat.add_comm, tds.iterate_add]

def orbitSeq {X : Type u} (T : X -> X) (x : X) : Nat -> X | 0 => x | n+1 => T (orbitSeq T x n)
def orbitSet {X : Type u} (T : X -> X) (x : X) : Set X := fun y => exists n : Nat, orbitSeq T x n = y
def TopDynamicalSystem.orbit (tds : TopDynamicalSystem X) (x : X) : Set X := orbitSet tds.T x

theorem self_mem_orbit {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) :
    Set.mem x (tds.orbit x) := by
  dsimp [TopDynamicalSystem.orbit, orbitSet, orbitSeq]; exact Exists.intro 0 rfl

theorem orbit_closed_under_T {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) :
    forall y, Set.mem y (tds.orbit x) -> Set.mem (tds.T y) (tds.orbit x) := by
  intro y hy; cases hy with | intro n hn =>
  dsimp [TopDynamicalSystem.orbit, orbitSet, orbitSeq]; exact Exists.intro (n+1) (by rw [orbitSeq, hn])

def omegaLimitSet {X : Type u} (T : X -> X) (x : X) : Set X :=
  fun y => forall N : Nat, exists n : Nat, n >= N And orbitSeq T x n = y
def IsRecurrent {X : Type u} (T : X -> X) (x : X) : Prop :=
  forall N : Nat, exists n : Nat, n >= N And orbitSeq T x n = x

def IsInvariant {X : Type u} (f : X -> X) (A : Set X) : Prop := forall x, Set.mem x A -> Set.mem (f x) A
def TopDynamicalSystem.IsInvariant (tds : TopDynamicalSystem X) (A : Set X) : Prop := IsInvariant tds.T A

theorem orbit_is_invariant {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) :
    tds.IsInvariant (tds.orbit x) := orbit_closed_under_T tds x

theorem invariant_iterate {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (A : Set X)
    (hA : tds.IsInvariant A) : forall n : Nat, forall x, Set.mem x A -> Set.mem (tds.iterate n x) A := by
  intro n; induction n with | zero => intro x hx; exact hx
  | succ k ih => intro x hx
    have h1 : Set.mem (tds.iterate k x) A := ih x hx
    have h2 : Set.mem (tds.T (tds.iterate k x)) A := hA (tds.iterate k x) h1
    simpa [tds.iterate] using h2

def IsFixedPoint {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) : Prop := tds.T x = x
def IsPeriodicPoint {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) (n : Nat) : Prop := 1 <= n And tds.iterate n x = x

theorem fixed_point_is_periodic {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X)
    (h : IsFixedPoint tds x) : IsPeriodicPoint tds x 1 := by
  refine And.intro ?_ ?_; exact Nat.le_refl 1; rw [tds.iterate, h]; rfl

def IsEventuallyPeriodic {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) : Prop :=
  exists m n : Nat, 1 <= n And tds.iterate (m + n) x = tds.iterate m x

def IsMinimalSet {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (M : Set X) : Prop :=
  Set.Nonempty M And IsClosed M And tds.IsInvariant M and
  (forall N : Set X, Set.Nonempty N -> IsClosed N -> tds.IsInvariant N -> Set.Subset N M -> N = M)

def IsMinimal {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) : Prop := IsMinimalSet tds Set.univ

def IsTopologicallyTransitive {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) : Prop :=
  forall U V : Set X, IsOpen U -> Set.Nonempty U -> IsOpen V -> Set.Nonempty V ->
    exists n : Nat, 1 <= n And Set.Nonempty (Set.inter (Set.image (tds.iterate n) U) V)

def IsTopologicallyMixing {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) : Prop :=
  forall U V : Set X, IsOpen U -> Set.Nonempty U -> IsOpen V -> Set.Nonempty V ->
    exists N : Nat, forall n : Nat, n >= N -> Set.Nonempty (Set.inter (Set.image (tds.iterate n) U) V)

theorem mixing_implies_transitive {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X)
    (hmix : IsTopologicallyMixing tds) : IsTopologicallyTransitive tds := by
  intro U V hU hUne hV hVne; rcases hmix U V hU hUne hV hVne with (N, hN)
  refine Exists.intro (N+1) (And.intro (by omega) (hN (N+1) (by omega)))

def IsProximalPair {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x y : X) : Prop :=
  forall U : Set X, IsOpen U -> Set.Nonempty U ->
    exists n : Nat, (Set.mem (tds.iterate n x) U) And (Set.mem (tds.iterate n y) U)

theorem proximal_reflexive {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) :
    IsProximalPair tds x x := by
  intro U hU hUne; exact Exists.intro 0 (And.intro (by dsimp [tds.iterate, Set.mem]; trivial) (by dsimp [tds.iterate, Set.mem]; trivial))

def IsDistalPair {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x y : X) : Prop := Not (IsProximalPair tds x y)
def IsDistal {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) : Prop := forall x y : X, x != y -> IsDistalPair tds x y

def HasDenseOrbit {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) : Prop :=
  forall U : Set X, IsOpen U -> Set.Nonempty U -> exists n : Nat, Set.mem (tds.iterate n x) U

def IsUniformlyRecurrent {X : Type u} [TopologicalSpace X] (tds : TopDynamicalSystem X) (x : X) : Prop :=
  forall U : Set X, IsOpen U -> Set.mem x U ->
    exists N : Nat, forall m : Nat, exists n : Nat, m <= n And n <= m + N And Set.mem (tds.iterate n x) U

def DiscreteTopology (X : Type u) : TopologicalSpace X where
  IsOpen := fun _ => True; isOpen_univ := trivial
  isOpen_inter := fun _ _ _ _ => trivial; isOpen_union := fun _ _ => trivial

#eval let tds : TopDynamicalSystem Nat := {
  T := fun n => n+1
  continuous_T := by
    haveI : TopologicalSpace Nat := DiscreteTopology Nat
    intro U hU; trivial }
  tds.iterate 5 0

#eval let tds : TopDynamicalSystem Nat := {
  T := fun n => (n+1)%7
  continuous_T := by
    haveI : TopologicalSpace Nat := DiscreteTopology Nat
    intro U hU; trivial }
  List.range 10 |>.map (fun k => tds.iterate k 3)

end MiniTopologicalDynamics
