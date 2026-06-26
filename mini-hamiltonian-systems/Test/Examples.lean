import MiniHamiltonianSystems

open MiniHamiltonianSystems

#eval "===== Examples Test ====="

def ho := harmonicOscillatorSystem 1.0 1 0.001
def pen := pendulumSystem 1.0 1.0 9.81 0.01
def kep := keplerSystem 1.0 2 0.01
def hh := henonHeilesSystem 0.01

#eval "--- Harmonic oscillator ---"
#eval ho.dim
def s0 : PhaseState := { position := [1.0], momentum := [0.0], dimension := 1, 
#eval ho.hamiltonian.evaluate s0

#eval "--- Pendulum ---"
#eval pen.dim
def ps0 : PhaseState := { position := [0.5], momentum := [0.0], dimension := 1, 
#eval pen.hamiltonian.evaluate ps0

#eval "--- Kepler ---"
#eval kep.dim
def ks0 : PhaseState := { position := [1.0, 0.0], momentum := [0.0, 0.5], dimension := 2, 
#eval kep.hamiltonian.evaluate ks0

#eval "--- Henon-Heiles ---"
def hs0 : PhaseState := { position := [0.3, 0.2], momentum := [0.1, 0.0], dimension := 2, 
#eval hh.hamiltonian.evaluate hs0

#eval "--- Flow ---"
#eval hamiltonianFlow ho s0 1.0 100
#eval phaseOrbit ho s0 0.1 5 |>.length

#eval "All examples tests passed"
