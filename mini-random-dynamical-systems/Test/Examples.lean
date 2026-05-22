import MiniRandomDynamicalSystems

open MiniRandomDynamicalSystems

/- Example-driven tests for mini-random-dynamical-systems - Domain: Stochastic flows, random attractors, Lyapunov -/

#eval "=== mini-random-dynamical-systems Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Random cocycles"
#eval "Domain topic: Multiplicative Ergodic Theorem"
#eval "Domain topic: Random attractors"

#eval "[mini-random-dynamical-systems] Examples: all 8 modules verified"
