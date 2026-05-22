/-
# MiniStabilityTheory: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Laws

namespace MiniStabilityTheory

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniStabilityTheory"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniStabilityTheory registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
