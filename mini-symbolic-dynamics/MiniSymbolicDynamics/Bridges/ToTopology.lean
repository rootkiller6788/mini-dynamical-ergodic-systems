/-
# MiniSymbolicDynamics: Bridges –To Topology
-/

import MiniObjectKernel.Core.Basic
import MiniSymbolicDynamics.Core.Basic

namespace MiniSymbolicDynamics

/-- Topological aspects. -/
def topologicalAspect : String := "Topological interpretation of MiniSymbolicDynamics"

/-- Connection to topological spaces. -/
def connectionToTopology : Axiom where
  name := "ConnectionToTopology"
  statement := "MiniSymbolicDynamics has a natural topological interpretation"
  proof := .sorry

#eval "── Bridges.ToTopology: MiniSymbolicDynamics –topology connection ──"
#eval topologicalAspect
