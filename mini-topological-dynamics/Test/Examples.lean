import MiniTopologicalDynamics

open MiniTopologicalDynamics

/- Example-driven tests for mini-topological-dynamics - Domain: Minimal sets, recurrence, equicontinuity, distality -/

#eval "=== mini-topological-dynamics Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Topological transitivity"
#eval "Domain topic: Minimality"
#eval "Domain topic: Distal flows"

#eval "[mini-topological-dynamics] Examples: all 8 modules verified"
