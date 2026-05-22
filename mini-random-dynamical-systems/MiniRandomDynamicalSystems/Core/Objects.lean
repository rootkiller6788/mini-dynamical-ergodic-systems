/-
# MiniRandomDynamicalSystems: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic
import MiniRandomDynamicalSystems.Core.Laws

namespace MiniRandomDynamicalSystems

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniRandomDynamicalSystems"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniRandomDynamicalSystems registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
