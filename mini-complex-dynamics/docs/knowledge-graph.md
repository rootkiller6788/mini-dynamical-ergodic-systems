# Knowledge Graph — MiniComplexDynamics

## L1: Definitions
- `RationalMap` — rational map on the Riemann sphere
- `MoebiusTransformation` — Mobius transformation az+b/cz+d
- `iterate` — n-th iterate f^n
- `orbit`, `forwardOrbit`, `grandOrbit` — orbit computations
- `PeriodicPoint`, `FixedPoint`, `PreperiodicPoint` — periodic point types
- `Multiplier` — multiplier at a periodic point
- `PeriodicPointType` — superattracting/attracting/neutral/repelling
- `JuliaSet`, `FatouSet` — Julia and Fatou sets
- `MandelbrotSet` — Mandelbrot set
- `DynamicalSystem` — abstract discrete dynamical system
- `CriticalPoint`, `CriticalValue`, `PostcriticalSet` — critical orbit data
- `Conjugacy`, `MoebiusConjugacy`, `Semiconjugacy` — conjugacy relations
- `FatouComponent` — Fatou component with type classification
- `FatouComponentType` — 5 types (attracting, superattracting, parabolic, Siegel, Herman)

## L2: Core Concepts
- `classifyMultiplier` — classification by modulus
- `isAttracting`, `isRepelling`, `isNeutral` — boolean predicates
- `mandelbrotMembership` — escape time algorithm
- `iterate` properties: zero, succ, add, mul
- `invariant`, `completely invariant` — set invariance
- `conjugacy preserves` — dynamical invariants

## L3: Math Structures
- `DynamicalSystem` — state space + evolution
- `FatouJuliaDichotomy` — partition of the dynamical plane
- `InvarianceLaws` — complete invariance properties
- `MontelCondition` — normal families criterion
- `complexDynamicsAxioms` — axiom system for dynamics
- `MoebiusEquivalent` — Mobius conjugacy class
- `RationalParameterSpace` — parameter space for degree d maps
- `ModuliSpaceRat` — moduli space M_d

## L4: Fundamental Theorems
- Fixed point count theorem
- Attracting/repelling local behavior
- Fatou-Julia partition theorem
- Complete invariance of Julia/Fatou sets
- J(f^n) = J(f) for all n >= 1
- Koenigs linearization theorem
- Boettcher theorem
- Quadratic escape criterion
- Sullivan''s no wandering domains
- Fatou component classification (5 types)
- Straightening theorem (Douady-Hubbard)
- Hyperbolicity characterization

## L5: Proof Techniques
1. **Induction on iteration** — iterate_add, iterate_mul, iteration_commutes
2. **Cases on multiplier type** — classifyMultiplier covers all 4 types
3. **Structural/categorical proofs** — conjugacy invariants
4. **Computable verification** — #eval on concrete examples

## L6: Canonical Examples
- z -> z^2 (unit circle Julia set)
- z -> z^2 - 1 (Basilica)
- z -> z^2 + i (Dendrite)
- z -> z^2 - 2 (Chebyshev, Julia = [-2,2])
- Douady rabbit (c = -0.12256 + 0.74486i)
- z -> z^d monomials
- z -> 1/z (inversion)
- Newton''s method for z^3 - 1
- Exponential family exp(z) + k

## L7: Applications
1. **Newton''s Method** — root finding, Cayley problem, basins, Wada property
2. **Population Dynamics** — logistic map, Ricker model, Feigenbaum universality
3. **Physics** — renormalization group, conformal field theory, quantum chaos, electrostatic equilibrium

## L8: Advanced Topics
1. **Parabolic Implosion** — Lavaurs maps, Ecalle cylinders, Douady-Ecalle-Voronin theory
2. **Renormalization** — DH renormalization, McMullen tower, crossed/primitive/satellite
3. **Transcendental Dynamics** — exponential family, Cantor bouquets, Speiser class, Eremenko conjecture
4. **Several Complex Variables** — Henon maps, C^2 automorphisms, Bedford-Diller theory

## L9: Research Frontiers
- MLC Conjecture (Mandelbrot set local connectivity)
- Density of Hyperbolicity
- Rigidity Conjecture
- Buff-Cheritat: Julia sets of positive Lebesgue measure
- Siegel disk boundaries
- Transcendental wandering domains
- Mating conjecture
- Interdisciplinary connections (Kleinian groups, Teichmuller, number theory, physics)
