/-
# MiniStabilityTheory: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic

namespace MiniStabilityTheory

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniStabilityTheory invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniStabilityTheory –computation connection ──"
#eval computationalAspect
