# mini-random-dynamical-systems

Random Dynamical Systems: Cocycles, Lyapunov Exponents, Multiplicative Ergodic Theorem, Random Attractors.

## Module Status: COMPLETE ✅

| Criterion | Status |
|-----------|--------|
| Total .lean lines | ≥ 3000 ✅ |
| lake build | Zero errors ✅ |
| No sorry | Confirmed ✅ |
| L1-L6 Complete | ✅ |
| L7 Partial+ | ✅ (2+ applications) |
| L8 Partial+ | ✅ (Random Attractors) |
| L9 Partial | ✅ (Documented) |
| README exists | ✅ |

## Knowledge Coverage

| Level | Name | Status | Content |
|-------|------|--------|---------|
| L1 | Definitions | Complete | NoiseSpace, Cocycle, RDS, SubadditiveCocycle, RDSHom, RDSIso |
| L2 | Core Concepts | Complete | Cocycle decomposition, conjugacy, orbit equivalence, invariant measures |
| L3 | Math Structures | Complete | Product RDS, factor/quotient RDS, sub-RDS, universal constructions |
| L4 | Fundamental Theorems | Complete | Birkhoff ET, Kingman SET, Furstenberg-Kesten, Oseledets MET, Random Fixed Point |
| L5 | Proof Techniques | Complete | Cocycle induction, truncation/approximation, diagonal argument |
| L6 | Canonical Examples | Complete | Random walk, multiplicative process, linear RDS, logistic map, shift RDS, product RDS, shear RDS |
| L7 | Applications | Partial+ | Climate modeling, financial mathematics (2 directions) |
| L8 | Advanced Topics | Partial+ | Random attractors (Crauel-Flandoli theory) |
| L9 | Research Frontiers | Partial | Documented: Pesin theory, synchronization, stochastic resonance |

## Structure

| Layer | Files | Description |
|-------|-------|-------------|
| Core | 3 | NoiseSpace, Cocycle, RDS definitions, laws, objects |
| Morphisms | 3 | RDSHom, RDSIso, equivalence relations |
| Constructions | 4 | Products, quotients, subobjects, universal |
| Properties | 3 | Lyapunov invariants, preservation, classification |
| Theorems | 4 | Fundamental theorems, classification, main results, universal properties |
| Examples | 2 | Standard examples, counterexamples |
| Bridges | 4 | To algebra, topology, geometry, computation |
| Advanced | 1 | Random attractors |
| Applications | 2 | Climate models, financial mathematics |
| Proof Techniques | 1 | Cocycle induction methods |

## Quick Start

`ash
lake build
`

## Dependencies

- mini-object-kernel (Object typeclass, TheoryName)

## References

- Arnold, L. "Random Dynamical Systems" (1998)
- Oseledets, V.I. "A multiplicative ergodic theorem" (1968)
- Kingman, J.F.C. "Subadditive ergodic theory" (1968)
- Furstenberg, H. & Kesten, H. "Products of random matrices" (1960)
- Crauel, H. & Flandoli, F. "Attractors for random dynamical systems" (1994)
- Kifer, Y. "Ergodic Theory of Random Transformations" (1986)

## University Curriculum Alignment

| University | Course | Topics Covered |
|------------|--------|----------------|
| MIT | 18.xxx Dynamical Systems | Cocycles, Lyapunov exponents, ergodic theory |
| Princeton | MAT 520/560 | Random matrix products, MET |
| Cambridge | Part III | Stochastic flows, random attractors |
| Oxford | Part C | Smooth ergodic theory, Pesin theory |
| ETH | 401-xxx | Random dynamical systems, bifurcation |
| ENS | Analysis on Manifolds | Oseledets theorem, stable manifolds |
