/-
# MiniTopologicalDynamics: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Theorems.Basic
import MiniTopologicalDynamics.Theorems.Classification

namespace MiniTopologicalDynamics

/-- Summary of main results. -/
def mainResults : List String := [
  "Fundamental theorem",
  "Structure theorem",
  "Classification theorem",
  "Duality theorem"
]

/-- Main gap theorem (Shelah-style). -/
def mainGap : Axiom where
  name := "MainGap"
  statement := "The main classification dichotomy for MiniTopologicalDynamics"
  proof := .sorry

#eval "── Theorems.Main: MiniTopologicalDynamics main results ──"
#eval mainResults
