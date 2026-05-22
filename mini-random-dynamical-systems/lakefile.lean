import Lake
open Lake DSL

package `«mini-random-dynamical-systems»` where

@[default_target]
lean_lib `«MiniRandomDynamicalSystems»` where
  roots := #[`MiniRandomDynamicalSystems]

require `«mini-object-kernel»` from "../../0. mini-math-kernel/mini-object-kernel"
require `«mini-topological-spaces»` from "../../10. mini-point-set-topology/mini-topological-spaces"
-- Determine other requires from Core/Basic.lean imports
