import MiniBifurcationTheory

open MiniBifurcationTheory

def main : IO Unit := do
  IO.println "Initializing MiniBifurcationTheory v0.1.0"
  IO.println "  DiscreteDS: iterated maps on type alpha"
  IO.println "  ParameterFamily: mu-parameterized dynamical systems"
  IO.println "  Bifurcation types: saddle-node, pitchfork, Hopf, period-doubling"
  IO.println "  Normal forms: universal unfoldings near bifurcation points"
  IO.println "  Stability: Lyapunov exponents and linear stability analysis"
  IO.println "  Codimension: classification of generic bifurcations"
  IO.println ""
  IO.println "Run `lake env lean --run Test/Smoke.lean` for tests."
