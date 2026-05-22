/-
# MiniRandomDynamicalSystems: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic

namespace MiniRandomDynamicalSystems

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniRandomDynamicalSystems invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniRandomDynamicalSystems –computation connection ──"
#eval computationalAspect
