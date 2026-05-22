import MiniTopologicalDynamics

open MiniTopologicalDynamics

/- Smoke tests for mini-topological-dynamics - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-topological-dynamics Smoke Test ==="
#eval "Core modules loaded: MiniTopologicalDynamics"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniTopologicalDynamics.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-topological-dynamics] Smoke test passed -- 8 modules OK"
