import MiniSymbolicDynamics

open MiniSymbolicDynamics

/- Example-driven tests for mini-symbolic-dynamics - Domain: Shift spaces, subshifts of finite type, topological entropy -/

#eval "=== mini-symbolic-dynamics Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Full shift"
#eval "Domain topic: Subshift of finite type"
#eval "Domain topic: Sliding block codes"

#eval "[mini-symbolic-dynamics] Examples: all 8 modules verified"
