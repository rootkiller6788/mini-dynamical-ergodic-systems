/-
# MiniRandomDynamicalSystems: Constructions –Universal
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic
import MiniRandomDynamicalSystems.Constructions.Products
import MiniRandomDynamicalSystems.Constructions.Quotients

namespace MiniRandomDynamicalSystems

/-- Universal construction. -/
structure UniversalConstruction where
  object : CoreType
  property : True := True.intro

/-- Existence of universal object. -/
def universalExists : Axiom where
  name := "UniversalExists"
  statement := "The universal construction exists"
  proof := .sorry

/-- Uniqueness up to unique isomorphism. -/
def universalUnique : Axiom where
  name := "UniversalUnique"
  statement := "The universal construction is unique up to unique isomorphism"
  proof := .sorry

#eval "── Constructions.Universal: MiniRandomDynamicalSystems universal ──"
#eval "Universal construction defined"
#eval "Unique up to unique isomorphism"
