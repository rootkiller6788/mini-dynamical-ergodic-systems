/-
# MiniHamiltonianSystems: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniHamiltonianSystems.Theorems.Basic
import MiniHamiltonianSystems.Theorems.Classification

namespace MiniHamiltonianSystems

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
  statement := "The main classification dichotomy for MiniHamiltonianSystems"
  proof := .sorry

#eval "── Theorems.Main: MiniHamiltonianSystems main results ──"
#eval mainResults
