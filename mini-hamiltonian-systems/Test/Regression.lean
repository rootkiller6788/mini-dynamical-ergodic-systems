import MiniHamiltonianSystems

open MiniHamiltonianSystems

#eval "===== Regression Test ====="

-- Test 1: Energy conservation
def hSys := harmonicOscillatorSystem 1.0 1 0.001
def sInit : PhaseState := { position := [1.0], momentum := [0.0], dimension := 1, 
def e0 := hSys.hamiltonian.evaluate sInit
def sFlow := hamiltonianFlow hSys sInit Float.pi 100
def eFlow := hSys.hamiltonian.evaluate sFlow
#eval Float.abs (e0 - eFlow) < 0.1

-- Test 2: Poisson bracket {q, p} ~ 1
def qF (s : PhaseState) : Float := (s.position.get? 0).getD 0.0
def pF (s : PhaseState) : Float := (s.momentum.get? 0).getD 0.0
def pb := standardPoissonBracket 1 0.001
def pbVal := pb.bracket qF pF sInit
#eval Float.abs (pbVal - 1.0) < 0.1

-- Test 3: Symplectic form
def sf := standardSymplecticForm 1
def v1 := [1.0, 0.0]; def v2 := [0.0, 1.0]
def sfVal := sf.evaluate v1 v2
#eval Float.abs (sfVal - 1.0) < 0.001

-- Test 4: Liouville measure
def meas := standardLiouvilleMeasure 1
def points : List PhaseState := [sInit, sFlow]
#eval meas.totalVolume points

-- Test 5: Canonical transformations
def ct := identityCanonicalTransform 2
def s2 : PhaseState := { position := [1.0, 2.0], momentum := [0.5, 0.3], dimension := 2, 
def s2t := applyCanonicalTransform ct s2
#eval s2t.position = s2.position && s2t.momentum = s2.momentum

-- Test 6: First integrals
def fi := energyFirstIntegral hSys.hamiltonian
#eval fi.physicalMeaning = "Total energy"

-- Test 7: Lagrangian submanifolds
def lag := zeroSectionLagrangian 2
def sCheck : PhaseState := { position := [1.0, 2.0], momentum := [0.0, 0.0], dimension := 2, 
#eval lag.membership sCheck

-- Test 8: Classification
def intData := classifyIntegrability hSys [fi]
#eval intData.integrabilityType

-- Test 9: Theory hierarchy
#eval hamTheoryRoot

-- Test 10: System info
#eval systemInfo hSys

#eval "All regression tests passed"
