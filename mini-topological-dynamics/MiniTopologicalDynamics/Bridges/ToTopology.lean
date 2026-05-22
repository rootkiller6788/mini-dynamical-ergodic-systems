/-
# MiniTopologicalDynamics: Bridges –To Topology
-/

import MiniObjectKernel.Core.Basic
import MiniTopologicalDynamics.Core.Basic

namespace MiniTopologicalDynamics

/-- Topological aspects. -/
def topologicalAspect : String := "Topological interpretation of MiniTopologicalDynamics"

/-- Connection to topological spaces. -/
def connectionToTopology : Axiom where
  name := "ConnectionToTopology"
  statement := "MiniTopologicalDynamics has a natural topological interpretation"
  proof := .sorry

#eval "── Bridges.ToTopology: MiniTopologicalDynamics –topology connection ──"
#eval topologicalAspect
