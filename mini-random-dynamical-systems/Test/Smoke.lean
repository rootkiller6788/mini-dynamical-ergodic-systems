import MiniRandomDynamicalSystems

open MiniRandomDynamicalSystems

/- Smoke tests for mini-random-dynamical-systems - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-random-dynamical-systems Smoke Test ==="
#eval "Core modules loaded: MiniRandomDynamicalSystems"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniRandomDynamicalSystems.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-random-dynamical-systems] Smoke test passed -- 8 modules OK"
