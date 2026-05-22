/-
# MiniBifurcationTheory: Constructions –Products
-/

import MiniObjectKernel.Core.Basic
import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Morphisms.Hom

namespace MiniBifurcationTheory

/-- Product of two objects. -/
structure Product (A B : CoreType) where
  left : A.carrier
  right : B.carrier

/-- Projection maps. -/
def projLeft {A B : CoreType} (p : Product A B) : A.carrier := p.left
def projRight {A B : CoreType} (p : Product A B) : B.carrier := p.right

/-- Universal property of product. -/
def productUniversal : Axiom where
  name := "ProductUniversalProperty"
  statement := "The product satisfies the universal property"
  proof := .sorry

#eval "── Constructions.Products: MiniBifurcationTheory product ──"
#eval "Product type defined"
#eval "Projections defined"
