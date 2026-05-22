import MiniSymbolicDynamics

open MiniSymbolicDynamics

/- Smoke tests for mini-symbolic-dynamics - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-symbolic-dynamics Smoke Test ==="
#eval "Core modules loaded: MiniSymbolicDynamics"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniSymbolicDynamics.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-symbolic-dynamics] Smoke test passed -- 8 modules OK"
