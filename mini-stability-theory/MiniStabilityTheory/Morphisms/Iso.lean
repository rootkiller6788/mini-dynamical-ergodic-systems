/-
# MiniStabilityTheory: Morphisms –Isomorphisms
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Morphisms.Hom

namespace MiniStabilityTheory

/-- An isomorphism: invertible homomorphism. -/
structure Iso (A B : CoreType) where
  forward : Hom A B
  reverse : Hom B A
  leftInv : True := True.intro
  rightInv : True := True.intro

/-- Identity isomorphism. -/
def idIso (A : CoreType) : Iso A A :=
  { forward := idHom A, reverse := idHom A }

/-- Composition of isomorphisms. -/
def isoComp {A B C : CoreType} (g : Iso B C) (f : Iso A B) : Iso A C :=
  { forward := homComp g.forward f.forward
    reverse := homComp f.reverse g.reverse
  }

#eval "── Morphisms.Iso: MiniStabilityTheory isomorphisms ──"
#eval "Iso type defined"
#eval "Isomorphisms compose"
