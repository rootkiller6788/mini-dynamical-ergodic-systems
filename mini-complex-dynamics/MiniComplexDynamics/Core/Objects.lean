/-
# MiniComplexDynamics: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws

namespace MiniComplexDynamics

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniComplexDynamics"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniComplexDynamics registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
