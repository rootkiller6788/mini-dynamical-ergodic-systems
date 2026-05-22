/-
# MiniTopologicalDynamics: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Core.Basic
import MiniTopologicalDynamics.Core.Laws

namespace MiniTopologicalDynamics

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniTopologicalDynamics"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniTopologicalDynamics registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
