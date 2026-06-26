/-
# Bifurcation Theory: Morphisms -- Isomorphisms

Topological conjugacy: the equivalence relation identifying
dynamical systems with the same qualitative behavior.
-/

import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Core.Objects
import MiniBifurcationTheory.Morphisms.Hom

namespace MiniBifurcationTheory

structure DynIso (X Y : Type) where
  f : X -> X
  g : Y -> Y
  phi : X -> Y
  psi : Y -> X
  leftInv : forall x, psi (phi x) = x
  rightInv : forall y, phi (psi y) = y
  commute : forall x, phi (f x) = g (phi x)

def DynIso.id (X : Type) (f : X -> X) : DynIso X X :=
  { f, g := f
  , phi := fun x => x, psi := fun x => x
  , leftInv := fun _ => rfl, rightInv := fun _ => rfl
  , commute := fun _ => rfl
  }

def DynIso.comp {X Y Z : Type} (iso1 : DynIso X Y) (iso2 : DynIso Y Z) (heq : iso1.g = iso2.f) : DynIso X Z :=
  { f := iso1.f, g := iso2.g
  , phi := fun x => iso2.phi (iso1.phi x)
  , psi := fun z => iso1.psi (iso2.psi z)
  , leftInv := fun x => by simp [iso1.leftInv, iso2.leftInv]
  , rightInv := fun z => by simp [iso1.rightInv, iso2.rightInv]
  , commute := fun x => by
      have h_comm : iso1.phi (iso1.f x) = iso2.f (iso1.phi x) := by
        rw [iso1.commute x, heq]
      calc
        iso2.phi (iso1.phi (iso1.f x)) = iso2.phi (iso2.f (iso1.phi x)) := by rw [h_comm]
        _ = iso2.g (iso2.phi (iso1.phi x)) := by rw [iso2.commute (iso1.phi x)]
  }

def DynIso.inv {X Y : Type} (iso : DynIso X Y) : DynIso Y X :=
  { f := iso.g, g := iso.f
  , phi := iso.psi, psi := iso.phi
  , leftInv := iso.rightInv, rightInv := iso.leftInv
  , commute := fun y => by
      calc
        iso.psi (iso.g y) = iso.psi (iso.g (iso.phi (iso.psi y))) := by rw [iso.rightInv]
        _ = iso.psi (iso.phi (iso.f (iso.psi y))) := by rw [iso.commute]
        _ = iso.f (iso.psi y) := by rw [iso.leftInv]
  }

def DynIso.toHom {X Y : Type} (iso : DynIso X Y) : DynHom X Y :=
  { f := iso.f, g := iso.g, phi := iso.phi, commute := iso.commute }

theorem phi_injective (iso : DynIso X Y) {a b : X} (h : iso.phi a = iso.phi b) : a = b := by
  calc
    a = iso.psi (iso.phi a) := by rw [iso.leftInv]
    _ = iso.psi (iso.phi b) := by rw [h]
    _ = b := by rw [iso.leftInv]

theorem fixedPoint_bijection (iso : DynIso X Y) (x : X) (hfp : isFixedPoint iso.f x) : isFixedPoint iso.g (iso.phi x) := by
  unfold isFixedPoint at hfp
  unfold isFixedPoint
  calc
    iso.g (iso.phi x) = iso.phi (iso.f x) := by rw [iso.commute]
    _ = iso.phi x := by rw [hfp]

theorem fixedPoint_bijection_inv (iso : DynIso X Y) (y : Y) (hfp : isFixedPoint iso.g y) : isFixedPoint iso.f (iso.psi y) := by
  unfold isFixedPoint at hfp
  unfold isFixedPoint
  calc
    iso.f (iso.psi y) = iso.psi (iso.phi (iso.f (iso.psi y))) := by rw [iso.leftInv]
    _ = iso.psi (iso.g (iso.phi (iso.psi y))) := by rw [iso.commute]
    _ = iso.psi (iso.g y) := by rw [iso.rightInv]
    _ = iso.psi y := by rw [hfp]

end MiniBifurcationTheory
