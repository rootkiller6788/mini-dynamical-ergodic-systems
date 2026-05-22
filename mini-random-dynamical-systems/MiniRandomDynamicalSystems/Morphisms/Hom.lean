/-
# MiniRandomDynamicalSystems: Morphisms –Homomorphisms
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic

namespace MiniRandomDynamicalSystems

/-- A homomorphism between objects. -/
structure Hom (A B : CoreType) where
  map : A.carrier →B.carrier
  preserves : True := True.intro

/-- Composition of homomorphisms. -/
def homComp {A B C : CoreType} (g : Hom B C) (f : Hom A B) : Hom A C :=
  { map := fun a => g.map (f.map a) }

/-- Identity homomorphism. -/
def idHom (A : CoreType) : Hom A A :=
  { map := fun a => a }

/-- Functoriality of the construction. -/
def functoriality : Axiom where
  name := "Functoriality"
  statement := "Hom respects composition and identities"
  proof := .sorry

#eval "── Morphisms.Hom: MiniRandomDynamicalSystems homomorphisms ──"
#eval "Hom type defined"
#eval "Composition and identity defined"
