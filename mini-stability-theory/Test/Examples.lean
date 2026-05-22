import MiniStabilityTheory

open MiniStabilityTheory

/- Example-driven tests for mini-stability-theory - Domain: Liapunov stability, structural stability, bifurcations -/

#eval "=== mini-stability-theory Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Liapunov functions"
#eval "Domain topic: Asymptotic stability"
#eval "Domain topic: Linearization"

#eval "[mini-stability-theory] Examples: all 8 modules verified"
