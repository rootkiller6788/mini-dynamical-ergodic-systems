import MiniTopologicalDynamics

open MiniTopologicalDynamics

def main : IO Unit := do
  IO.println "═══════════════════════════════════════════"
  IO.println "  MiniTopologicalDynamics v0.1.0"
  IO.println "  Topological Dynamics of Dynamical Systems"
  IO.println "═══════════════════════════════════════════"
  IO.println s!"  Topological Dynamical System: continuous map T on space X"
  IO.println s!"  Minimality: no proper closed invariant subsets"
  IO.println s!"  Recurrence: Birkhoff, Auslander-Ellis, Furstenberg"
  IO.println s!"  Classification: proximal, distal, regionally proximal"
  IO.println s!"  Entropy: topological entropy and variational principle"
  IO.println s!"  Examples: irrational rotation, shift, adding machine"
  IO.println ""
  IO.println "  Run `lake build` to compile all theorems."
