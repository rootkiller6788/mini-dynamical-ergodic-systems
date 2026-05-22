/-
# MiniHamiltonianSystems: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniHamiltonianSystems.Core.Basic
import MiniHamiltonianSystems.Core.Laws

namespace MiniHamiltonianSystems

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniHamiltonianSystems"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniHamiltonianSystems registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
