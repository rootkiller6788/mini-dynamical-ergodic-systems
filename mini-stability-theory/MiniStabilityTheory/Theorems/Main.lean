/-
# MiniStabilityTheory: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Theorems.Basic
import MiniStabilityTheory.Theorems.Classification

namespace MiniStabilityTheory

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
  statement := "The main classification dichotomy for MiniStabilityTheory"
  proof := .sorry

#eval "── Theorems.Main: MiniStabilityTheory main results ──"
#eval mainResults
