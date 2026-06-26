import Lake
open Lake DSL

package "mini-symbolic-dynamics" where

@[default_target]
lean_lib "MiniSymbolicDynamics" where
  moreLeanArgs := #["-DmaxHeartbeats=400000"]

lean_exe "smoke-test" where
  root := `Test.Smoke
  supportInterpreter := true
