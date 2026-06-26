import Lake
open Lake DSL

package «mini-random-dynamical-systems» where

require «mini-object-kernel» from "../../0. mini-math-kernel/mini-object-kernel"

@[default_target]
lean_lib «MiniRandomDynamicalSystems» where
  moreLeanArgs := #["-DmaxHeartbeats=400000"]
