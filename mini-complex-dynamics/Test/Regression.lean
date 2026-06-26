/- Test/Regression.lean - Regression test suite -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

def main : IO Unit := do
  IO.println "══════════════════════════════════"
  IO.println "  Regression Test Suite"
  IO.println "══════════════════════════════════"

  -- Test: Forward orbit always has correct length
  let orb5 := forwardOrbit (fun z => z*z) (ComplexNumbers.of 1 0) 5
  assert! (orb5.length == 6)

  -- Test: iterate zero is identity
  assert! (iterate (fun z => z*z) 0 (ComplexNumbers.of 3 0) = ComplexNumbers.of 3 0)

  -- Test: iterate_succ correct
  assert! (iterate (fun z => z*z) 3 (ComplexNumbers.of 2 0) =
           (fun z => z*z) (iterate (fun z => z*z) 2 (ComplexNumbers.of 2 0)))

  -- Test: Mandelbrot membership at known points
  assert! (mandelbrotMembership (ComplexNumbers.of 0 0) 50 2.0 = true)
  assert! (mandelbrotMembership (ComplexNumbers.of 2 0) 50 2.0 = false)

  -- Test: escape test on clearly escaping point
  let (iters, escaped) := testEscape (fun z => z*z) (ComplexNumbers.of 3 0) 20 10.0
  assert! escaped

  -- Test: non-escaping point
  let (iters2, escaped2) := testEscape (fun z => z*z) (ComplexNumbers.of 0.5 0) 20 10.0
  assert! (!escaped2)

  IO.println s!"  All regression tests PASSED ✅"
  IO.println "══════════════════════════════════"
