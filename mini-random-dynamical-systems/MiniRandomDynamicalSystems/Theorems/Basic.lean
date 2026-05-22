/-
# MiniRandomDynamicalSystems: Theorems –Basic
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic
import MiniRandomDynamicalSystems.Core.Laws
import MiniRandomDynamicalSystems.Morphisms.Iso
import MiniRandomDynamicalSystems.Properties.Invariants

namespace MiniRandomDynamicalSystems

/-- First fundamental theorem. -/
def fundamentalTheorem : Axiom where
  name := "FundamentalTheorem"
  statement := "The fundamental theorem of MiniRandomDynamicalSystems"
  proof := .sorry

/-- Structure theorem. -/
def structureTheorem : Axiom where
  name := "StructureTheorem"
  statement := "Every object in MiniRandomDynamicalSystems has a canonical decomposition"
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

#eval "── Theorems.Basic: MiniRandomDynamicalSystems key theorems ──"
#eval "Fundamental theorem stated"
#eval "Structure theorem stated"
#eval "Existence and uniqueness stated"
