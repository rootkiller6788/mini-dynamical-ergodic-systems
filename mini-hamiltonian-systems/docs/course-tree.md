# Course Tree — mini-hamiltonian-systems

## Prerequisites
```
mini-object-kernel (from ../../0. mini-math-kernel/mini-object-kernel)
├── Object, TheoryName structures
│
mini-axiom-kernel (from ../../0. mini-math-kernel/mini-axiom-kernel)
├── Axiom definition framework
│
mini-real-numbers (from ../../6. mini-real-analysis/mini-real-numbers)
├── Float, Real numbers
│
mini-vector-space-core (from ../../3. mini-linear-multilinear-algebra/mini-vector-space-core)
├── Vector space operations (List Float)
│
mini-hamiltonian-systems (this module)
├── Core/Basic.lean → PhaseState, SymplecticForm, HamiltonianFunction, etc.
├── Core/Laws.lean → Energy conservation, symplectic preservation, etc.
├── Core/Objects.lean → Object instances, theory registration
├── Morphisms/ → Hamiltonian morphisms, equivalences, isomorphisms
├── Constructions/ → Products, quotients (symplectic reduction), subobjects, universal
├── Properties/ → Invariants, preservation, classification data
├── Theorems/ → Liouville, Noether, Darboux, Arnold-Liouville, Poincare, etc.
├── Examples/ → Standard examples + counterexamples
├── Bridges/ → Algebra, topology, analysis, geometry, computation
├── Applications/ → Mechanics, celestial dynamics, quantum mechanics
├── Advanced/ → Integrable systems, KAM, symplectic topology, Poisson geometry
└── Frontiers/ → Research frontiers (Floer, HMS, SFT, etc.)
```

## Downstream Dependencies
```
mini-hamiltonian-systems
├── mini-ergodic-theory (statistical mechanics foundations)
├── mini-bifurcation-theory (Hamiltonian bifurcations)
├── mini-symplectic-geometry (in 13. mini-differential-riemannian-geometry)
└── mini-stability-theory (Hamiltonian stability analysis)
```
