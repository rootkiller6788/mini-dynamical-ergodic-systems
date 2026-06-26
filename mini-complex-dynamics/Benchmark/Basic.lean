/- Benchmark/Basic.lean - Benchmark for basic complex dynamics operations -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

#eval "══ Basic Benchmark: Complex Dynamics ══"

#eval "── Iteration ──"
#eval iterate (fun z => z*z) 10 (ComplexNumbers.of 1.5 0)
#eval forwardOrbit (fun z => z*z) (ComplexNumbers.of 0.5 0) 8

#eval "── Mandelbrot ──"
#eval mandelbrotMembership (ComplexNumbers.of (-1) 0) 100 2.0
#eval mandelbrotMembership (ComplexNumbers.of 0.25 0) 100 2.0

#eval "── Multiplier Classification ──"
#eval classifyMultiplier (ComplexNumbers.of 0 0)
#eval classifyMultiplier (ComplexNumbers.of 0.5 0)
#eval classifyMultiplier (ComplexNumbers.of 2 0)

#eval "╌ Basic benchmark complete ╌"
