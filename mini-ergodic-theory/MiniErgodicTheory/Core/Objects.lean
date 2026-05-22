/-
# MiniErgodicTheory: Object Registrations
-/

import MiniObjectKernel.Core.Basic
import MiniErgodicTheory.Core.Basic
import MiniErgodicTheory.Core.Laws

namespace MiniErgodicTheory

def registerTheory : IO Unit :=
  IO.println s!"Theory registered: MiniErgodicTheory"

def theoryRegistry : List String := [
  "CoreType", "Law1", "Law2", "Law3"
]

#eval "── Core.Objects: MiniErgodicTheory registrations ──"
#eval registerTheory
#eval s!"Registered: {theoryRegistry}"
