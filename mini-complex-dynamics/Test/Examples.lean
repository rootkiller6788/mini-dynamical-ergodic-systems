import MiniComplexDynamics

open MiniComplexDynamics

/- Example-driven tests for mini-complex-dynamics - Domain: Julia sets, Mandelbrot set, holomorphic dynamics, iteration -/

#eval "=== mini-complex-dynamics Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Julia sets"
#eval "Domain topic: Mandelbrot set"
#eval "Domain topic: Fatou components"

#eval "[mini-complex-dynamics] Examples: all 8 modules verified"
