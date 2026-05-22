/-
# MiniSymbolicDynamics: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniSymbolicDynamics.Core.Basic

namespace MiniSymbolicDynamics

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniSymbolicDynamics invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniSymbolicDynamics –computation connection ──"
#eval computationalAspect
