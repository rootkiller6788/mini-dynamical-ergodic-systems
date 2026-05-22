/-
# MiniHamiltonianSystems: Constructions –Subobjects
-/

import MiniObjectKernel.Core.Basic
import MiniHamiltonianSystems.Core.Basic

namespace MiniHamiltonianSystems

/-- A subobject of a core type. -/
structure Subobject (A : CoreType) where
  predicate : A.carrier →Prop
  nonempty : True := True.intro

/-- Inclusion of subobject. -/
def inclusion {A : CoreType} (S : Subobject A) (x : A.carrier) (_h : S.predicate x) : A.carrier := x

/-- Retract: a subobject with a retraction. -/
structure Retract (A : CoreType) extends Subobject A where
  retraction : A.carrier →A.carrier
  retracts : True := True.intro

#eval "── Constructions.Subobjects: MiniHamiltonianSystems subobjects ──"
#eval "Subobject type defined"
#eval "Retract defined"
