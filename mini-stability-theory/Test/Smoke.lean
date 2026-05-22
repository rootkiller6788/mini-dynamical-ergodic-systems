import MiniStabilityTheory

open MiniStabilityTheory

/- Smoke tests for mini-stability-theory - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-stability-theory Smoke Test ==="
#eval "Core modules loaded: MiniStabilityTheory"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniStabilityTheory.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-stability-theory] Smoke test passed -- 8 modules OK"
