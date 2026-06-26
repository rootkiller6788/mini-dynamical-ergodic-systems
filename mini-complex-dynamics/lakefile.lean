import Lake
open Lake DSL

package «mini-complex-dynamics» where

require «mini-object-kernel» from "../../0. mini-math-kernel/mini-object-kernel"
require «mini-complex-numbers» from "../../7. mini-complex-analysis-riemann/mini-complex-numbers"

@[default_target]
lean_lib «MiniComplexDynamics» where
  moreLeanArgs := #["-DmaxHeartbeats=400000"]

/-- Smoke test executable. -/
lean_exe «smoke-test» where
  root := `Test.Smoke
  supportInterpreter := true

/-- Examples regression test. -/
lean_exe «example-test» where
  root := `Test.Examples
  supportInterpreter := true

/-- Regression test suite. -/
lean_exe «regression-test» where
  root := `Test.Regression
  supportInterpreter := true
