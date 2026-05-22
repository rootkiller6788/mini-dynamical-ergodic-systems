import MiniRandomDynamicalSystems

open MiniRandomDynamicalSystems

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniRandomDynamicalSystems v0.1.0"
  IO.println "  Stochastic flows, random attractors, Lyapunov exponents"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniRandomDynamicalSystems"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-random-dynamical-systems entry point verified"
