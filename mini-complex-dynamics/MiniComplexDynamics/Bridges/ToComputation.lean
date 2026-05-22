/-
# MiniComplexDynamics: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniComplexDynamics.Core.Basic

namespace MiniComplexDynamics

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniComplexDynamics invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniComplexDynamics –computation connection ──"
#eval computationalAspect
