/-
# MiniRandomDynamicalSystems: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Theorems.Basic
import MiniRandomDynamicalSystems.Theorems.Classification

namespace MiniRandomDynamicalSystems

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
  statement := "The main classification dichotomy for MiniRandomDynamicalSystems"
  proof := .sorry

#eval "── Theorems.Main: MiniRandomDynamicalSystems main results ──"
#eval mainResults
