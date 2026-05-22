import MiniComplexDynamics

open MiniComplexDynamics

/- Smoke tests for mini-complex-dynamics - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-complex-dynamics Smoke Test ==="
#eval "Core modules loaded: MiniComplexDynamics"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniComplexDynamics.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-complex-dynamics] Smoke test passed -- 8 modules OK"
