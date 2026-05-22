/-
# MiniTopologicalDynamics: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Core.Basic

namespace MiniTopologicalDynamics

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniTopologicalDynamics invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniTopologicalDynamics –computation connection ──"
#eval computationalAspect
