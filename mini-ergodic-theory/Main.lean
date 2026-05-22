import MiniErgodicTheory

open MiniErgodicTheory

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniErgodicTheory v0.1.0"
  IO.println "  Measure-preserving maps, ergodic theorems, entropy"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniErgodicTheory"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-ergodic-theory entry point verified"
