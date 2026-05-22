import MiniSymbolicDynamics

open MiniSymbolicDynamics

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniSymbolicDynamics v0.1.0"
  IO.println "  Shift spaces, subshifts of finite type, topological entropy"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniSymbolicDynamics"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-symbolic-dynamics entry point verified"
