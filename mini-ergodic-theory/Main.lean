import MiniErgodicTheory

open MiniErgodicTheory

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniErgodicTheory v0.1.0"
  IO.println "  Ergodic Theory: Measure-Preserving Systems,"
  IO.println "  Birkhoff Theorem, Entropy, Recurrence"
  IO.println "═══════════════════════════════════════"
  IO.println "  Core: DynSystem, Ergodicity, Mixing, Measure-Preserving"
  IO.println "  Theorems: Birkhoff Pointwise Ergodic, Von Neumann Mean Ergodic,"
  IO.println "            Poincaré Recurrence, Kryloff-Bogoliuboff"
  IO.println "  Operators: Koopman Formalism, Spectral Characterizations"
  IO.println "  Examples: Irrational Rotations, Bernoulli Shifts, Markov Shifts"
  IO.println "  Applications: Equidistribution, Normal Numbers, Statistical Mechanics"
  IO.println "  Advanced: Kolmogorov-Sinai Entropy, Multiple Recurrence"
  IO.println ""
  IO.println "  Run `lake build` to compile all modules."
