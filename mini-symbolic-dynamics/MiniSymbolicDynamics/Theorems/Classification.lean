/-
# MiniSymbolicDynamics: Theorems –Classification
-/

import MiniObjectKernel.Core.Basic
import MiniSymbolicDynamics.Core.Basic
import MiniSymbolicDynamics.Properties.ClassificationData

namespace MiniSymbolicDynamics

/-- Classification theorem. -/
def classifyAll : Axiom where
  name := "ClassifyAll"
  statement := "All objects of MiniSymbolicDynamics are classified"
  proof := .sorry

/-- Enumeration of classes. -/
def enumerateClasses : List String := [
  "Class 1: description",
  "Class 2: description",
  "Class 3: description"
]

#eval "── Theorems.Classification: MiniSymbolicDynamics classification ──"
#eval enumerateClasses
