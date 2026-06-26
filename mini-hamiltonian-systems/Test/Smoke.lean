import MiniHamiltonianSystems

open MiniHamiltonianSystems

-- Smoke test: basic definitions exist and #eval
#eval "Smoke test: MiniHamiltonianSystems v0.1.0"

-- PhaseState creation
#eval zeroState 3
#eval mkPhaseState [1.0, 2.0] [0.5, 0.3]

-- Hamiltonian systems
#eval harmonicOscillatorSystem 1.0 1 0.001 |>.dim
#eval pendulumSystem 1.0 1.0 9.81 0.001 |>.dim

-- Energy calculations
#eval harmonicOscillator 1.0 1 |>.evaluate (zeroState 1)
#eval pendulumHamiltonian 1.0 1.0 9.81 |>.evaluate ({ position := [0.5], momentum := [0.0], dimension := 1, 

-- Symplectic form
#eval standardSymplecticForm 2 |>.dimension

-- Poisson bracket
#eval standardPoissonBracket 1 0.001 |>.bracket (fun s => (s.position.get? 0).getD 0.0) (fun s => (s.momentum.get? 0).getD 0.0) (zeroState 1)

-- Liouville measure
#eval standardLiouvilleMeasure 2 |>.dimension

-- Flow computation
#eval symplecticEulerStep (harmonicOscillatorSystem 1.0 1 0.001) 0.1 (zeroState 1)

#eval "All smoke tests passed"
