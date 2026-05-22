/-
# MiniStabilityTheory: Theorems –Universal Properties
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Constructions.Universal

namespace MiniStabilityTheory

/-- Universal property of product. -/
def productUniversalProperty : Axiom where
  name := "ProductUniversalProperty"
  statement := "Product satisfies the universal mapping property"
  proof := .sorry

/-- Universal property of quotient. -/
def quotientUniversalProperty : Axiom where
  name := "QuotientUniversalProperty"
  statement := "Quotient satisfies the universal mapping property"
  proof := .sorry

/-- Adjoint functor relationship. -/
def adjunction : Axiom where
  name := "Adjunction"
  statement := "There is an adjunction between the relevant functors"
  proof := .sorry

#eval "── Theorems.UniversalProperties: MiniStabilityTheory universal properties ──"
#eval "Product and quotient universal properties stated"
#eval "Adjunction stated"
