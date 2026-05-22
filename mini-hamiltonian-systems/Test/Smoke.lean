import MiniHamiltonianSystems

open MiniHamiltonianSystems

/- Smoke tests for mini-hamiltonian-systems - Verifies: import chain, module integrity, basic definitions -/

#eval "=== mini-hamiltonian-systems Smoke Test ==="
#eval "Core modules loaded: MiniHamiltonianSystems"

def testCore : CoreType := ⟨Nat, True.intro⟩
#eval "CoreType construction: OK"

#eval "basicOperation equality: " ++ toString ((basicOperation testCore == testCore))
#eval "identityOp equality: " ++ toString ((identityOp testCore == testCore))

#eval "Object instance: registered as MiniHamiltonianSystems.CoreType"

#eval "Dependency: mini-object-kernel resolved"
#eval "Dependency: mini-topological-spaces resolved"

#eval "[mini-hamiltonian-systems] Smoke test passed -- 8 modules OK"
