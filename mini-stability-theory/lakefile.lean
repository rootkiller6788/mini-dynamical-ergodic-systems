import Lake
open Lake DSL

package `«mini-stability-theory»` where

@[default_target]
lean_lib `«MiniStabilityTheory»` where
  roots := #[`MiniStabilityTheory]

require `«mini-object-kernel»` from "../../0. mini-math-kernel/mini-object-kernel"
require `«mini-topological-spaces»` from "../../10. mini-point-set-topology/mini-topological-spaces"
-- Determine other requires from Core/Basic.lean imports
