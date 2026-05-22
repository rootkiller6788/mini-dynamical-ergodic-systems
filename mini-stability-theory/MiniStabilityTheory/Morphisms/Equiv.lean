/-
# MiniStabilityTheory: Morphisms –Equivalences
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Morphisms.Hom
import MiniStabilityTheory.Morphisms.Iso

namespace MiniStabilityTheory

/-- Equivalence relation on objects. -/
def isEquivalent (A B : CoreType) : Prop := Nonempty (Iso A B)

/-- Equivalence is reflexive. -/
def equivRefl (A : CoreType) : isEquivalent A A :=
  ⟨idIso A⟩
/-- Equivalence is symmetric. -/
def equivSymm {A B : CoreType} (h : isEquivalent A B) : isEquivalent B A :=
  let ⟨iso⟩:= h; ⟨{ forward := iso.reverse, reverse := iso.forward }⟩
/-- Equivalence is transitive. -/
def equivTrans {A B C : CoreType} (h1 : isEquivalent A B) (h2 : isEquivalent B C) : isEquivalent A C :=
  let ⟨i1⟩:= h1; let ⟨i2⟩:= h2; ⟨isoComp i2 i1⟩
#eval "── Morphisms.Equiv: MiniStabilityTheory equivalences ──"
#eval "Equivalence relation defined (reflexive, symmetric, transitive)"
