/-
# MiniSymbolicDynamics: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniSymbolicDynamics.Core.Basic
import MiniSymbolicDynamics.Core.Laws

namespace MiniSymbolicDynamics

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniSymbolicDynamics"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniSymbolicDynamics registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
