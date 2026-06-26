# Architecture: MiniRandomDynamicalSystems

## Module Structure

| Layer | Files | Lines | Description |
|-------|-------|-------|-------------|
| Core | 3 | ~650 | NoiseSpace, Cocycle, RDS, Laws, Objects |
| Morphisms | 3 | ~480 | RDSHom, RDSIso, Orbit equivalence |
| Constructions | 4 | ~310 | Product, factor, sub-RDS, universal |
| Properties | 3 | ~295 | Lyapunov invariants, preservation, classification |
| Theorems | 4 | ~340 | Birkhoff, MET, Furstenberg-Kesten, universal |
| Examples | 2 | ~330 | 8 standard + 5 counterexamples |
| Bridges | 4 | ~255 | Algebra, Topology, Geometry, Computation |
| Advanced | 1 | ~90 | Random attractors |
| Applications | 2 | ~150 | Climate, Finance |
| ProofTechniques | 1 | ~107 | Cocycle induction, 3 methods |
| Test | 3 | ~100 | Smoke, examples, regression |
| Benchmark | 5 | ~85 | University coverage |

## Dependencies
- mini-object-kernel (Object typeclass, TheoryName)
