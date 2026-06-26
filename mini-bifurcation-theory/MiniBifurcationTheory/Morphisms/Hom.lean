/-
# Bifurcation Theory: Morphisms -- Homomorphisms

Maps between dynamical systems that preserve structure: semiconjugacies,
factor maps, and orbit homomorphisms.
-/

import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Core.Objects
import MiniBifurcationTheory.Core.Laws

namespace MiniBifurcationTheory

structure DynHom (X Y : Type) where
  f : X -> X
  g : Y -> Y
  phi : X -> Y
  commute : forall x, phi (f x) = g (phi x)

def DynHom.id (X : Type) (f : X -> X) : DynHom X X :=
  { f, g := f, phi := fun x => x, commute := fun _ => rfl }

def DynHom.comp {X Y Z : Type} (h1 : DynHom X Y) (h2 : DynHom Y Z) (heq : h1.g = h2.f) : DynHom X Z :=
  { f := h1.f, g := h2.g
  , phi := fun x => h2.phi (h1.phi x)
  , commute := fun x => by
      have h1_comm : h1.phi (h1.f x) = h2.f (h1.phi x) := by
        rw [h1.commute x, heq]
      calc
        h2.phi (h1.phi (h1.f x)) = h2.phi (h2.f (h1.phi x)) := by rw [h1_comm]
        _ = h2.g (h2.phi (h1.phi x)) := by rw [h2.commute (h1.phi x)]
  }

theorem orbit_hom (hom : DynHom X Y) (x : X) (n : Nat) : hom.phi (orbit hom.f x n) = orbit hom.g (hom.phi x) n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp [orbit, hom.commute, ih]

theorem fixedPoint_hom (hom : DynHom X Y) (x : X) (h : isFixedPoint hom.f x) : isFixedPoint hom.g (hom.phi x) := by
  unfold isFixedPoint at h
  unfold isFixedPoint
  calc
    hom.g (hom.phi x) = hom.phi (hom.f x) := by rw [hom.commute]
    _ = hom.phi x := by rw [h]

theorem periodic_hom (hom : DynHom X Y) (x : X) (n : Nat) (h : isPeriodicPoint hom.f x n) : orbit hom.g (hom.phi x) n = hom.phi x := by
  have horb := h.1
  calc
    orbit hom.g (hom.phi x) n = hom.phi (orbit hom.f x n) := by rw [orbit_hom]
    _ = hom.phi x := by rw [horb]

structure BifurcationDiagramMap where
  source : ParameterFamily Rat Rat
  target : ParameterFamily Rat Rat
  paramMap : Rat -> Rat
  stateMap : Rat -> Rat
  commute : forall mu x, stateMap (source.f mu x) = target.f (paramMap mu) (stateMap x)

end MiniBifurcationTheory
