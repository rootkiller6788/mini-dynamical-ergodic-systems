import Lake
open Lake DSL

package «mini-hamiltonian-systems» where

@[default_target]
lean_lib «MiniHamiltonianSystems» where
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
