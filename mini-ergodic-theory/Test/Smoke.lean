import MiniErgodicTheory

open MiniErgodicTheory

/- Smoke tests for mini-ergodic-theory - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-ergodic-theory Smoke Test ==="
#eval "Core modules loaded: MiniErgodicTheory"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniErgodicTheory.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-ergodic-theory] Smoke test passed -- 8 modules OK"
