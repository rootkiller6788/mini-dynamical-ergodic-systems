/- Benchmark/JuliaBench.lean - Julia set computation benchmarks -/

import MiniComplexDynamics

open MiniComplexDynamics
open MiniComplexNumbers

#eval "══ Julia Set Benchmark ══"

#eval "── Escape time for z^2-1 ──"
#eval escapeTimeJulia (fun z => z*z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 0.5 0.5) 100 2.0

#eval "── Forward orbits ──"
#eval forwardOrbit (fun z => z*z + ComplexNumbers.of (-1) 0) (ComplexNumbers.of 0 0) 12

#eval "── Basilica critical orbit ──"
#eval basilicaCriticalOrbit

#eval "╌ Julia benchmark complete ╌"
