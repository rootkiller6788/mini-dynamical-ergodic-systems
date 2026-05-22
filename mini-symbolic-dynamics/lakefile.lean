import Lake
open Lake DSL

package `«mini-symbolic-dynamics»` where

@[default_target]
lean_lib `«MiniSymbolicDynamics»` where
  roots := #[`MiniSymbolicDynamics]

require `«mini-object-kernel»` from "../../0. mini-math-kernel/mini-object-kernel"
require `«mini-topological-spaces»` from "../../10. mini-point-set-topology/mini-topological-spaces"
-- Determine other requires from Core/Basic.lean imports
