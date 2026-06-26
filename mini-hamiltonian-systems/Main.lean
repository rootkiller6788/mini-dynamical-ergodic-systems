import MiniHamiltonianSystems

open MiniHamiltonianSystems

def main : IO Unit := do
  IO.println "════════════════════════════════════════════"
  IO.println "  MiniHamiltonianSystems v0.1.0"
  IO.println "  Hamiltonian Dynamics: Symplectic Geometry,"
  IO.println "  Liouville Theorem, Noether Theorem,"
  IO.println "  Integrable Systems, KAM Theory"
  IO.println "════════════════════════════════════════════"

  IO.println s!"  Hamiltonian axioms: {hamiltonianAxiomCount}"
  IO.println s!"  Core theorems: {coreTheoremRegistry.length}"
  IO.println s!"  Integrable system types: 4"
  IO.println s!"  Liouville measure computation: available"
  IO.println s!"  Research frontiers tracked: {frontierRegistry.length}"
  IO.println s!"  Coverage: 30+ definitions, 25+ theorems, 9 levels"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
