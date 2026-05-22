/-
# MiniHamiltonianSystems: Constructions –Quotients
-/

import MiniObjectKernel.Core.Basic
import MiniHamiltonianSystems.Core.Basic

namespace MiniHamiltonianSystems

/-- Quotient by an equivalence relation. -/
def Quotient (A : CoreType) (R : A.carrier →A.carrier →Prop) : Type :=
  Quot R

/-- Natural projection. -/
def naturalProj {A : CoreType} {R : A.carrier →A.carrier →Prop} (a : A.carrier) : Quotient A R :=
  Quot.mk R a

/-- Universal property of quotient. -/
def quotientUniversal : Axiom where
  name := "QuotientUniversalProperty"
  statement := "The quotient satisfies the universal property"
  proof := .sorry

#eval "── Constructions.Quotients: MiniHamiltonianSystems quotients ──"
#eval "Quotient type defined"
#eval "Natural projection defined"
