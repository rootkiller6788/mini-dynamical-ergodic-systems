/- Benchmark/FullSuite.lean - Full complex dynamics benchmark suite -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

#eval "══════════════════════════════════════════════"
#eval "  Full Complex Dynamics Benchmark Suite"
#eval "══════════════════════════════════════════════"

#eval "── 1. Axiom System ──"
#eval dynamicsAxiomCount
#eval dynamicsAxiomNames

#eval "── 2. Iteration ──"
#eval forwardOrbit (fun z => z*z) (ComplexNumbers.of 2 0) 5
#eval forwardOrbit (fun z => z*z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 0 0) 10

#eval "── 3. Mandelbrot ──"
#eval mandelbrotMembership (ComplexNumbers.of (-1) 0) 100 2.0
#eval mandelbrotMembership (ComplexNumbers.of 0.25 0) 100 2.0

#eval "── 4. Multipliers ──"
#eval classifyMultiplier (ComplexNumbers.of 0 0)
#eval classifyMultiplier (ComplexNumbers.of 0.5 0)
#eval classifyMultiplier (ComplexNumbers.of 1 0)
#eval classifyMultiplier (ComplexNumbers.of 2 0)

#eval "── 5. Theorem Registry ──"
#eval coreTheoremRegistry.length
#eval coreTheoremRegistry.map (·.name)

#eval "── 6. Objects ──"
#eval describe RationalMap
#eval describe PeriodicPointType

#eval "── 7. Frontiers ──"
#eval frontierRegistry.topics.length

#eval "══════════════════════════════════════════════"
#eval "  Benchmark Complete"
#eval "══════════════════════════════════════════════"
