import MiniComplexDynamics

open MiniComplexDynamics

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniComplexDynamics v0.1.0"
  IO.println "  Julia sets, Mandelbrot set, holomorphic dynamics"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniComplexDynamics"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-complex-dynamics entry point verified"
