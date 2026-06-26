import Lake
open Lake DSL

package «mini-ergodic-theory» where
  -- Ergodic theory package: measure-preserving systems, Birkhoff theorem, entropy

require std from git "https://github.com/leanprover/std4" @ "main"

@[default_target]
lean_lib «MiniErgodicTheory» where
  roots := #[`MiniErgodicTheory]
