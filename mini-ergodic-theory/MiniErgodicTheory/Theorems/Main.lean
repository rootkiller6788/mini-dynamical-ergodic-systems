/-
# MiniErgodicTheory: Theorems –Main Results
-/

import MiniObjectKernel.Core.Basic
import MiniErgodicTheory.Theorems.Basic
import MiniErgodicTheory.Theorems.Classification

namespace MiniErgodicTheory

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
  statement := "The main classification dichotomy for MiniErgodicTheory"
  proof := .sorry

#eval "── Theorems.Main: MiniErgodicTheory main results ──"
#eval mainResults
