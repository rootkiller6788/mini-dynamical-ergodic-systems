/-
# MiniBifurcationTheory: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniBifurcationTheory.Theorems.Basic
import MiniBifurcationTheory.Theorems.Classification

namespace MiniBifurcationTheory

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
  statement := "The main classification dichotomy for MiniBifurcationTheory"
  proof := .sorry

#eval "── Theorems.Main: MiniBifurcationTheory main results ──"
#eval mainResults
