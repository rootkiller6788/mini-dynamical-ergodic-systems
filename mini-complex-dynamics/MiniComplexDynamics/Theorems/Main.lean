/-
# MiniComplexDynamics: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniComplexDynamics.Theorems.Basic
import MiniComplexDynamics.Theorems.Classification

namespace MiniComplexDynamics

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
  statement := "The main classification dichotomy for MiniComplexDynamics"
  proof := .sorry

#eval "── Theorems.Main: MiniComplexDynamics main results ──"
#eval mainResults
