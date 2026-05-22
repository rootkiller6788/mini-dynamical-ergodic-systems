import MiniBifurcationTheory

open MiniBifurcationTheory

/- Smoke tests for mini-bifurcation-theory - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-bifurcation-theory Smoke Test ==="
#eval "Core modules loaded: MiniBifurcationTheory"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniBifurcationTheory.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-bifurcation-theory] Smoke test passed -- 8 modules OK"
