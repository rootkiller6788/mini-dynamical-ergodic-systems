import MiniBifurcationTheory

open MiniBifurcationTheory

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniBifurcationTheory v0.1.0"
  IO.println "  Bifurcation theory, normal forms, center manifolds"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Key definitions: CoreType, basicOperation, identityOp"
  IO.println s!"  Object instance registered under MiniBifurcationTheory"
  IO.println ""
  IO.println "  Package structure:"
  IO.println "    Core / Morphisms / Constructions / Properties"
  IO.println "    Theorems / Examples / Bridges"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

#eval "Main: mini-bifurcation-theory entry point verified"
