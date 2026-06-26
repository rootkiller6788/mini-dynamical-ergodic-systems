import MiniComplexDynamics

open MiniComplexDynamics

def main : IO Unit := do
  IO.println "════════════════════════════════════════════"
  IO.println "  MiniComplexDynamics v0.1.0"
  IO.println "  Complex Dynamics: Julia Sets, Fatou Sets,"
  IO.println "  Mandelbrot Set, Iteration Theory"
  IO.println "════════════════════════════════════════════"

  IO.println s!"  Dynamics axioms: {dynamicsAxiomCount}"
  IO.println s!"  Core theorems: {coreTheoremRegistry.length}"
  IO.println s!"  Fatou component types: 5"
  IO.println s!"  Mandelbrot membership algorithm: available"
  IO.println s!"  Research frontiers tracked: {frontierRegistry.topics.length}"
  IO.println s!"  Coverage: 30+ definitions, 25+ theorems, 9 levels"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
