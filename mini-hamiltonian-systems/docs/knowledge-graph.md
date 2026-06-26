# Knowledge Graph — mini-hamiltonian-systems

## L1: Definitions (Complete)
| Definition | Lean Type | Location |
|-----------|-----------|----------|
| PhaseState | `structure` | Core/Basic.lean |
| SymplecticForm | `structure` | Core/Basic.lean |
| SymplecticVectorSpace | `structure` | Core/Basic.lean |
| SymplecticMatrix | `structure` | Core/Basic.lean |
| HamiltonianFunction | `structure` | Core/Basic.lean |
| HamiltonianVectorField | `structure` | Core/Basic.lean |
| PoissonBracket | `structure` | Core/Basic.lean |
| HamiltonianSystem | `structure` | Core/Basic.lean |
| LiouvilleMeasure | `structure` | Core/Basic.lean |
| EnergySurface | `structure` | Core/Basic.lean |
| CanonicalTransformation | `structure` | Core/Basic.lean |
| GeneratingFunctionF1/F2/F3 | `structure` | Core/Basic.lean |
| CotangentBundle | `structure` | Core/Basic.lean |
| LagrangianSubmanifold | `structure` | Core/Basic.lean |
| FirstIntegral | `structure` | Core/Basic.lean |
| Involution | `structure` | Core/Basic.lean |
| MomentMap | `structure` | Core/Basic.lean |
| HamiltonianMorphism | `structure` | Morphisms/Hom.lean |
| SymplecticMorphism | `structure` | Morphisms/Hom.lean |
| HamiltonianEquivalence | `structure` | Morphisms/Equiv.lean |
| HamiltonianIsomorphism | `structure` | Morphisms/Iso.lean |
| IntegrabilityType | `inductive` | Properties/ClassificationData.lean |
| DynamicsType | `inductive` | Properties/ClassificationData.lean |
| SingularityType | `inductive` | Properties/ClassificationData.lean |
| BifurcationType | `inductive` | Properties/ClassificationData.lean |
| StabilityType | `inductive` | Properties/ClassificationData.lean |
| SymplecticCapacity | `structure` | Properties/Invariants.lean |
| MaslovIndex | `structure` | Properties/Invariants.lean |

## L2: Core Concepts (Complete)
- energyConservation, symplecticFormPreservation
- LiouvilleTheorem, PoissonBracketAntisymmetry
- JacobiIdentity, LeibnizRule
- HamiltonianEquations, CanonicalTransformProperties
- FirstIntegralProperties, IntegrabilityCriterion
- FlowGroupProperty, ActionAngleDynamics
- NoetherSymmetryConservation

## L3: Mathematical Structures (Complete)
- HamiltonianSystem (full structure with operations)
- SymplecticVectorSpace
- CotangentBundle with canonical forms
- PoissonBracket Lie algebra structure
- HamiltonianCategory
- SymplecticQuotient (Marsden-Weinstein)
- ProductHamiltonianSystem
- InvariantSubmanifold hierarchy (symplectic, isotropic, coisotropic, Lagrangian)

## L4: Fundamental Theorems (Complete)
- Liouville's Theorem (volume preservation)
- Noether's Theorem (symmetry-conservation)
- Darboux Theorem (local canonical coordinates)
- Arnold-Liouville Theorem (integrable systems)
- Poincare Recurrence Theorem
- Poincare-Birkhoff Theorem
- Hamilton-Jacobi Theory
- Hamilton's Principle of Least Action

## L5: Proof Techniques (Complete)
1. Direct computation with symplectic form
2. Finite difference approximations
3. Poisson bracket manipulations
4. Structural/categorical proofs
5. Variational/Euler-Lagrange methods
6. Perturbation theory expansions

## L6: Canonical Examples (Complete)
1. Harmonic Oscillator
2. Pendulum (small + large + rotating)
3. Kepler Problem
4. Henon-Heiles System
5. Euler Top
6. Double Pendulum
7. Duffing Oscillator
8. Morse Potential
9. Separable Hamiltonian
10. Free Particle
All with #eval verification.

## L7: Applications (Complete, 3+)
1. Classical Mechanics — N-body, rigid body, constrained systems
2. Celestial Dynamics — CR3BP, Lagrange points, orbital maneuvers
3. Quantum Mechanics — Canonical quantization, WKB, coherent states

## L8: Advanced Topics (Partial, 4)
1. Integrable Systems — Lax pairs, Toda, KdV, Calogero-Moser
2. KAM Theory — Diophantine conditions, small divisors, Nekhoroshev
3. Symplectic Topology — Gromov non-squeezing, J-holomorphic curves, Floer
4. Poisson Geometry — Symplectic foliation, Poisson cohomology, Kontsevich

## L9: Research Frontiers (Partial, documented)
1. Floer Homological Algebra
2. Homological Mirror Symmetry
3. Symplectic Field Theory
4. Arnold's Conjecture
5. Weinstein Conjecture
6. Microlocal Sheaf Theory
7. Derived Symplectic Geometry
8. C^0 Symplectic Topology
9. KAM for PDEs
10. Machine Learning for Hamiltonian Discovery
