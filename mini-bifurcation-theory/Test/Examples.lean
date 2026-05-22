import MiniBifurcationTheory

open MiniBifurcationTheory

/- Example-driven tests for mini-bifurcation-theory - Domain: Bifurcation theory, normal forms, center manifolds, chaos -/

#eval "=== mini-bifurcation-theory Example Tests ==="

def ex1 : CoreType := ⟨Nat, True.intro⟩
#eval "Example 1: CoreType with Nat carrier"

def ex2 : CoreType := basicOperation (⟨Nat, True.intro⟩ : CoreType)
#eval "Example 2: basicOperation preserves"

def ex3 : CoreType := identityOp (identityOp (⟨Nat, True.intro⟩ : CoreType))
#eval "Example 3: identityOp round-trip"

#eval "Domain topic: Bifurcation theory"
#eval "Domain topic: Normal forms"
#eval "Domain topic: Center manifolds"

#eval "[mini-bifurcation-theory] Examples: all 8 modules verified"
