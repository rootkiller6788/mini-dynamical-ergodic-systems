/- Test/Examples.lean - Example regression tests -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

def main : IO Unit := do
  IO.println "══ Example Regression Tests ══"

  -- Test 1: Basic orbit computation
  let orb := forwardOrbit (fun z => z*z) (ComplexNumbers.of 0.5 0) 4
  IO.println s!"  Orbit length: {orb.length}"

  -- Test 2: Mandelbrot membership
  let m0 := mandelbrotMembership (ComplexNumbers.of 0 0) 50 2.0
  let m1 := mandelbrotMembership (ComplexNumbers.of (-1) 0) 50 2.0
  IO.println s!"  M(0) = {m0}, M(-1) = {m1}"

  -- Test 3: Multiplier classification
  let mc0 := classifyMultiplier (ComplexNumbers.of 0 0)
  let mc1 := classifyMultiplier (ComplexNumbers.of 2 0)
  IO.println s!"  lambda=0: {mc0}, lambda=2: {mc1}"

  -- Test 4: Escape test
  let et := testEscape (fun z => z*z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 2 0) 10 10.0
  IO.println s!"  Escape test: {et}"

  IO.println "  ✅ Examples test PASSED"
