/-
# MiniErgodicTheory: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniErgodicTheory.Core.Basic

namespace MiniErgodicTheory

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniErgodicTheory invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniErgodicTheory –computation connection ──"
#eval computationalAspect
