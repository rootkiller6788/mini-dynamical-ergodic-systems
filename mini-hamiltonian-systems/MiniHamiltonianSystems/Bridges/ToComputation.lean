/-
# MiniHamiltonianSystems: Bridges –To Computation
-/

import MiniObjectKernel.Core.Basic
import MiniHamiltonianSystems.Core.Basic

namespace MiniHamiltonianSystems

/-- Computational aspects. -/
def computationalAspect : String := "Computability of MiniHamiltonianSystems invariants"

/-- Algorithm for computing the invariant. -/
def computeInvariant : Axiom where
  name := "ComputeInvariant"
  statement := "There is an algorithm to compute the invariant"
  proof := .sorry

#eval "── Bridges.ToComputation: MiniHamiltonianSystems –computation connection ──"
#eval computationalAspect
