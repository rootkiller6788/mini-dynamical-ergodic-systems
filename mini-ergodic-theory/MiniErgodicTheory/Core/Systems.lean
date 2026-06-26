import Std
import MiniErgodicTheory.Core.Basic
namespace MiniErgodicTheory

variable {a b c : Type} [Fintype a] [DecidableEq a] [Fintype b] [DecidableEq b]
  [Fintype c] [DecidableEq c]

def DynSystem.product (sys1 : DynSystem a) (sys2 : DynSystem b) : DynSystem (a * b) where
  T := fun (x, y) => (sys1.T x, sys2.T y)

theorem DynSystem.product_pow (sys1 : DynSystem a) (sys2 : DynSystem b) (n : Nat) (x : a) (y : b) :
    (DynSystem.product sys1 sys2).pow n (x, y) = (sys1.pow n x, sys2.pow n y) := by
  induction n with
  | zero => simp
  | succ n ih => simp [DynSystem.product, DynSystem.pow_succ, ih]

def MPDS.product (sys1 : MPDS a) (sys2 : MPDS b) : MPDS (a * b) :=
  let T_prod : (a * b) -> (a * b) := fun (x, y) => (sys1.T x, sys2.T y)
  let prob_prod := ProbabilityMeasure.product sys1.prob sys2.prob
  have hpres : forall A : Finset (a * b),
      prob_prod.setMeasure A =
      prob_prod.setMeasure (Finset.filter (fun z => T_prod z ∈ A) Finset.univ) := by
    intro A
    dsimp [ProbabilityMeasure.setMeasure, prob_prod, ProbabilityMeasure.product]
    native_decide
  MPDS.mk' T_prod prob_prod hpres

structure FactorMap (sys1 : MPDS a) (sys2 : MPDS b) where
  pi : a -> b
  intertwining : forall x : a, pi (sys1.T x) = sys2.T (pi x)
  measure_preserving : forall B : Finset b,
    sys1.prob.setMeasure (Finset.filter (fun x => pi x in B) Finset.univ) =
    sys2.prob.setMeasure B

def FactorMap.id (sys : MPDS a) : FactorMap sys sys where
  pi := id
  intertwining := by intro x; rfl
  measure_preserving := by intro B; simp

def FactorMap.comp {sys1 : MPDS a} {sys2 : MPDS b} {sys3 : MPDS c}
    (f : FactorMap sys1 sys2) (g : FactorMap sys2 sys3) : FactorMap sys1 sys3 where
  pi := g.pi o f.pi
  intertwining := by intro x; simp [g.intertwining, f.intertwining]
  measure_preserving := by
    intro C
    calc
      sys1.prob.setMeasure (Finset.filter (fun x => (g.pi o f.pi) x in C) Finset.univ)
          = sys1.prob.setMeasure (Finset.filter (fun x => f.pi x ∈ filter (fun y => g.pi y in C) Finset.univ) Finset.univ) := by
        simp [Finset.mem_filter, and_comm, and_assoc]
      _ = sys2.prob.setMeasure (Finset.filter (fun y => g.pi y in C) Finset.univ) :=
        f.measure_preserving _
      _ = sys3.prob.setMeasure C := g.measure_preserving _

structure MPDS.Isomorphic (sys1 : MPDS a) (sys2 : MPDS b) where
  forward : FactorMap sys1 sys2
  backward : FactorMap sys2 sys1
  left_inv : forall x, backward.pi (forward.pi x) = x
  right_inv : forall y, forward.pi (backward.pi y) = y

theorem MPDS.isomorphic_refl (sys : MPDS a) : MPDS.Isomorphic sys sys where
  forward := FactorMap.id sys
  backward := FactorMap.id sys
  left_inv := by intro x; rfl
  right_inv := by intro x; rfl

theorem MPDS.isomorphic_symm {sys1 : MPDS a} {sys2 : MPDS b}
    (h : MPDS.Isomorphic sys1 sys2) : MPDS.Isomorphic sys2 sys1 where
  forward := h.backward
  backward := h.forward
  left_inv := h.right_inv
  right_inv := h.left_inv

theorem MPDS.isomorphic_trans {sys1 : MPDS a} {sys2 : MPDS b} {sys3 : MPDS c}
    (h12 : MPDS.Isomorphic sys1 sys2) (h23 : MPDS.Isomorphic sys2 sys3) :
    MPDS.Isomorphic sys1 sys3 where
  forward := FactorMap.comp h12.forward h23.forward
  backward := FactorMap.comp h23.backward h12.backward
  left_inv := by intro x; simp [h12.left_inv, h23.left_inv, FactorMap.comp]
  right_inv := by intro y; simp [h12.right_inv, h23.right_inv, FactorMap.comp]

def projectionFactorMap (sys1 : MPDS a) (sys2 : MPDS b) :
    FactorMap (MPDS.product sys1 sys2) sys1 where
  pi := Prod.fst
  intertwining := by intro (x, y); rfl
  measure_preserving := by
    intro B
    simp [MPDS.product, ProbabilityMeasure.setMeasure, ProbabilityMeasure.product]

def diagonalEmbedding (sys : MPDS a) : FactorMap sys (MPDS.product sys sys) where
  pi := fun x => (x, x)
  intertwining := by intro x; rfl
  measure_preserving := by
    intro B
    simp [MPDS.product, ProbabilityMeasure.setMeasure, ProbabilityMeasure.product]

example : let T1 : DynSystem (Fin 2) := DynSystem.mk id
  let T2 : DynSystem (Fin 3) := DynSystem.mk id
  let T_prod := DynSystem.product T1 T2
  T_prod.pow 3 (Fin.mk 0 (by omega), Fin.mk 1 (by omega)) =
  (Fin.mk 0 (by omega), Fin.mk 1 (by omega)) := by
  intro T1 T2 T_prod
  unfold T_prod DynSystem.product T1 T2 DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

example : let T1 : DynSystem (Fin 2) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 2 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  let T2 : DynSystem (Fin 3) := DynSystem.mk (fun x =>
    if h : x.val + 1 < 3 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega))
  let T_prod := DynSystem.product T1 T2
  T_prod.pow 6 (Fin.mk 0 (by omega), Fin.mk 0 (by omega)) =
  (Fin.mk 0 (by omega), Fin.mk 0 (by omega)) := by
  intro T1 T2 T_prod
  unfold T_prod DynSystem.product T1 T2 DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

def DynSystem.coupled (sys1 : DynSystem a) (sys2 : DynSystem b)
    (coupling : a -> b -> b) : DynSystem (a * b) where
  T := fun (x, y) => (sys1.T x, coupling x y)

def DynSystem.skewProduct (sys_base : DynSystem a)
    (fiber_map : a -> (b -> b)) : DynSystem (a * b) where
  T := fun (x, y) => (sys_base.T x, fiber_map x y)

example : let skew : DynSystem (Fin 2 * Fin 2) :=
    DynSystem.skewProduct (DynSystem.mk (fun (x : Fin 2) =>
      if h : x.val + 1 < 2 then Fin.mk (x.val + 1) h else Fin.mk 0 (by omega)))
    (fun (x : Fin 2) => fun (y : Fin 2) =>
      if x.val = 0 then y else
      if h : y.val + 1 < 2 then Fin.mk (y.val + 1) h else Fin.mk 0 (by omega))
  skew.pow 2 (Fin.mk 0 (by omega), Fin.mk 0 (by omega)) =
  (Fin.mk 0 (by omega), Fin.mk 0 (by omega)) := by
  intro skew
  unfold skew DynSystem.skewProduct DynSystem.mk DynSystem.pow DynSystem.iterate
  native_decide

end MiniErgodicTheory
