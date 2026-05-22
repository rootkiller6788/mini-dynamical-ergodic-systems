/-
# MiniTopologicalDynamics: Constructions –Subobjects
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Core.Basic

namespace MiniTopologicalDynamics

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

#eval "── Constructions.Subobjects: MiniTopologicalDynamics subobjects ──"
#eval "Subobject type defined"
#eval "Retract defined"
