/-
# MiniRandomDynamicalSystems: Bridges –To Topology
-/

import MiniObjectKernel.Core.Basic
import MiniRandomDynamicalSystems.Core.Basic

namespace MiniRandomDynamicalSystems

/-- Topological aspects. -/
def topologicalAspect : String := "Topological interpretation of MiniRandomDynamicalSystems"

/-- Connection to topological spaces. -/
def connectionToTopology : Axiom where
  name := "ConnectionToTopology"
  statement := "MiniRandomDynamicalSystems has a natural topological interpretation"
  proof := .sorry

#eval "── Bridges.ToTopology: MiniRandomDynamicalSystems –topology connection ──"
#eval topologicalAspect
