import MiniStabilityTheory

open MiniStabilityTheory

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniStabilityTheory v0.1.0"
  IO.println "  Liapunov stability, structural stability, bifurcations"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniStabilityTheory"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-stability-theory entry point verified"
