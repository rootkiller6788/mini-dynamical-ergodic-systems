/-
# MiniTopologicalDynamics: Theorems –Basic
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Core.Basic
import MiniTopologicalDynamics.Core.Laws
import MiniTopologicalDynamics.Morphisms.Iso
import MiniTopologicalDynamics.Properties.Invariants

namespace MiniTopologicalDynamics

/-- First fundamental theorem. -/
def fundamentalTheorem : Axiom where
  name := "FundamentalTheorem"
  statement := "The fundamental theorem of MiniTopologicalDynamics"
  proof := .sorry

/-- Structure theorem. -/
def structureTheorem : Axiom where
  name := "StructureTheorem"
  statement := "Every object in MiniTopologicalDynamics has a canonical decomposition"
  proof := .sorry

/-- Existence theorem. -/
def existenceTheorem : Axiom where
  name := "ExistenceTheorem"
  statement := "Objects with given invariants always exist"
  proof := .sorry

/-- Uniqueness theorem. -/
def uniquenessTheorem : Axiom where
  name := "UniquenessTheorem"
  statement := "The object with given invariant is unique up to isomorphism"
  proof := .sorry

#eval "── Theorems.Basic: MiniTopologicalDynamics key theorems ──"
#eval "Fundamental theorem stated"
#eval "Structure theorem stated"
#eval "Existence and uniqueness stated"
