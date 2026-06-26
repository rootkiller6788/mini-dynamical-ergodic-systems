/-
# Benchmark: MIT 18.03/18.06 Course Alignment
-/
import MiniStabilityTheory
open MiniStabilityTheory

def test_mit_1803_phase_plane : IO Unit := do
  let saddle : LinearSystem2D := { a11 := 1.0, a12 := 2.0, a21 := 3.0, a22 := -1.0 }
  let stableNode : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
  let stableFocus : LinearSystem2D := { a11 := -1.0, a12 := 2.0, a21 := -2.0, a22 := -1.0 }
  let center : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -4.0, a22 := 0.0 }
  IO.println s!"Saddle: {saddle.classify}, Stable Node: {stableNode.classify}"
  IO.println s!"Stable Focus: {stableFocus.classify}, Center: {center.classify}"

def test_mit_1803_linearization : IO Unit := do
  let J : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -1.0, a22 := 1.0 }
  IO.println s!"Van der Pol origin (mu=1): {J.classify}"
  let J2 : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -9.8, a22 := -0.5 }
  IO.println s!"Damped pendulum bottom: {J2.classify}"

def test_mit_1806_eigenvalues : IO Unit := do
  let A : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
  let evs := A.eigenvalues
  IO.println s!"Eigenvalues: {evs}, Stable: {A.isStable}"

#eval test_mit_1803_phase_plane; #eval test_mit_1803_linearization; #eval test_mit_1806_eigenvalues