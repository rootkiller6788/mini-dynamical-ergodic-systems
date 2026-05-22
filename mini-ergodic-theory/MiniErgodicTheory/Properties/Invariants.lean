/-
# MiniErgodicTheory: Properties –Invariants
-/

import MiniObjectKernel.Core.Basic
import MiniErgodicTheory.Core.Basic

namespace MiniErgodicTheory

/-- An invariant of the structure under isomorphism. -/
def invariant (A : CoreType) : Nat := 0 -- stub

/-- Invariants are preserved under isomorphism. -/
def invariantPreserved : Axiom where
  name := "InvariantPreserved"
  statement := "Invariants take the same value on isomorphic objects"
  proof := .sorry

/-- The fundamental invariant. -/
def fundamentalInvariant (A : CoreType) : String := "MiniErgodicTheory-invariant"

#eval "── Properties.Invariants: MiniErgodicTheory invariants ──"
#eval "fundamentalInvariant defined"
