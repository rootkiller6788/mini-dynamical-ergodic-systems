/-
# MiniBifurcationTheory: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Core.Laws

namespace MiniBifurcationTheory

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniBifurcationTheory"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniBifurcationTheory registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
