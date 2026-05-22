/-
# MiniSymbolicDynamics: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniSymbolicDynamics.Theorems.Basic
import MiniSymbolicDynamics.Theorems.Classification

namespace MiniSymbolicDynamics

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
  statement := "The main classification dichotomy for MiniSymbolicDynamics"
  proof := .sorry

#eval "── Theorems.Main: MiniSymbolicDynamics main results ──"
#eval mainResults
