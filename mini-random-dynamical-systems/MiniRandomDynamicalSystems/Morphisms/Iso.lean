/-
# MiniRandomDynamicalSystems: Morphisms –Isomorphisms
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic
import MiniRandomDynamicalSystems.Morphisms.Hom

namespace MiniRandomDynamicalSystems

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

#eval "── Morphisms.Iso: MiniRandomDynamicalSystems isomorphisms ──"
#eval "Iso type defined"
#eval "Isomorphisms compose"
