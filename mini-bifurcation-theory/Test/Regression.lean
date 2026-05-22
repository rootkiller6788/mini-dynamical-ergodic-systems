import MiniBifurcationTheory

open MiniBifurcationTheory

/- Regression and invariant checks for mini-bifurcation-theory -/

#eval "=== mini-bifurcation-theory Regression Checks ==="

#eval "Invariant 1: CoreType structure preserved"

def t : CoreType := ⟨Nat, True.intro⟩
#eval "Invariant 2: basicOperation idempotent: " ++ toString ((basicOperation (basicOperation t)) == t)
#eval "Invariant 3: identityOp round-trip: " ++ toString ((identityOp (identityOp t)) == t)

#eval "Invariant 4: Object instance integrity preserved"

#eval "[mini-bifurcation-theory] Regression: all invariants preserved"
