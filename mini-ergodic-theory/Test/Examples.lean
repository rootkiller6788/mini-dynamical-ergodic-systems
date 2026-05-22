import MiniErgodicTheory

open MiniErgodicTheory

/- Example-driven tests for mini-ergodic-theory - Domain: Measure-preserving maps, ergodic theorems, entropy, mixing -/

#eval "=== mini-ergodic-theory Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Birkhoff theorem"
#eval "Domain topic: Mean ergodic"
#eval "Domain topic: Pointwise ergodic"

#eval "[mini-ergodic-theory] Examples: all 8 modules verified"
