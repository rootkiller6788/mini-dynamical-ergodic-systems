/- Benchmark/MandelbrotBench.lean - Mandelbrot set benchmarks -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

#eval "══ Mandelbrot Set Benchmark ══"

#eval "── Membership tests ──"
#eval mandelbrotMembership (ComplexNumbers.of 0 0) 200 2.0
#eval mandelbrotMembership (ComplexNumbers.of (-1) 0) 200 2.0
#eval mandelbrotMembership (ComplexNumbers.of 0.25 0) 200 2.0
#eval mandelbrotMembership (ComplexNumbers.of (-2) 0) 200 2.0

#eval "── Boundary test (c = 1/4) ──"
#eval mandelbrotMembership (ComplexNumbers.of 0.25 0) 500 2.0

#eval "── Real slice scan ──"
#eval (List.range 21).map fun i =>
  let c := ComplexNumbers.of (-2.0 + Float.ofNat i * 0.2) 0
  (c, mandelbrotMembership c 100 2.0)

#eval "╌ Mandelbrot benchmark complete ╌"
