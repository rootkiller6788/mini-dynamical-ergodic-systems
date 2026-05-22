/-
# MiniStabilityTheory: Properties –Invariants
-/

import MiniObjectKernel.Core.Basic
import MiniStabilityTheory.Core.Basic

namespace MiniStabilityTheory

/-- An invariant of the structure under isomorphism. -/
def invariant (A : CoreType) : Nat := 0 -- stub

/-- Invariants are preserved under isomorphism. -/
def invariantPreserved : Axiom where
  name := "InvariantPreserved"
  statement := "Invariants take the same value on isomorphic objects"
  proof := .sorry

/-- The fundamental invariant. -/
def fundamentalInvariant (A : CoreType) : String := "MiniStabilityTheory-invariant"

#eval "── Properties.Invariants: MiniStabilityTheory invariants ──"
#eval "fundamentalInvariant defined"
