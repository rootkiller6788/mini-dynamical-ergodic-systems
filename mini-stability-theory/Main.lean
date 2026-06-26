import MiniStabilityTheory

open MiniStabilityTheory

def main : IO Unit := do
  IO.println "==========================================="
  IO.println "  MiniStabilityTheory v0.1.0"
  IO.println "  Stability Theory of Dynamical Systems"
  IO.println "==========================================="
  IO.println s!"  Lyapunov stability: stability in the sense of Lyapunov"
  IO.println s!"  Asymptotic and exponential stability: convergence rates"
  IO.println s!"  Linear stability: eigenvalue and multiplier criteria"
  IO.println s!"  Structural stability: robustness under perturbations"
  IO.println s!"  Lyapunov functions: direct method for nonlinear systems"
  IO.println s!"  LaSalle invariance principle"
  IO.println s!"  Hartman-Grobman theorem: linearization near hyperbolic eq."
  IO.println s!"  Center manifold and stable/unstable manifold theorems"
  IO.println s!"  Input-to-state stability (ISS) and absolute stability"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
