/-
# MiniErgodicTheory: Theorems –Classification
-/

import MiniObjectKernel.Core.Basic
import MiniErgodicTheory.Core.Basic
import MiniErgodicTheory.Properties.ClassificationData

namespace MiniErgodicTheory

/-- Classification theorem. -/
def classifyAll : Axiom where
  name := "ClassifyAll"
  statement := "All objects of MiniErgodicTheory are classified"
  proof := .sorry

/-- Enumeration of classes. -/
def enumerateClasses : List String := [
  "Class 1: description",
  "Class 2: description",
  "Class 3: description"
]

#eval "── Theorems.Classification: MiniErgodicTheory classification ──"
#eval enumerateClasses
