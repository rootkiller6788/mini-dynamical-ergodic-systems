/- Benchmark/IterationBench.lean - Iteration theory benchmarks -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

#eval "══ Iteration Benchmark ══"

#eval "── Iterate properties ──"
#eval iterate (fun z => z*z) 0 (ComplexNumbers.of 5 0)
#eval iterate (fun z => z*z) 5 (ComplexNumbers.of 2 0)
#eval iterate (fun z => z*z) 10 (ComplexNumbers.of 1.1 0)

#eval "── Escape test ──"
#eval testEscape (fun z => z*z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 1 0) 20 10.0

#eval "╌ Iteration benchmark complete ╌"
