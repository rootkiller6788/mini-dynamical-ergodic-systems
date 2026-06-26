# MiniComplexDynamics

Complex dynamics in Lean 4: iteration of rational maps on the Riemann sphere,
Julia sets, Fatou sets, Mandelbrot set, periodic point classification,
conjugacies, and advanced topics.

## Module Status: COMPLETE

- **L1**: Complete — RationalMap, JuliaSet, FatouSet, MandelbrotSet, PeriodicPoint, MoebiusTransformation, Multiplier, DynamicalSystem, CriticalPoint, PostcriticalSet, Conjugacy, Semiconjugacy
- **L2**: Complete — isAttracting, isRepelling, isNeutral, isSuperattracting, classifyMultiplier, iterate, orbit, forwardOrbit, grandOrbit
- **L3**: Complete — DynamicalSystem, RationalParameterSpace, ConnectednessLocus, UniversalModel, FatouJuliaDichotomy, InvarianceLaws, MontelCondition
- **L4**: Complete — Fixed point count theorem, Attracting basin theorem, Repelling density theorem, Fatou-Julia partition, Julia/Fatou complete invariance, J(f^n) = J(f), Koenigs and Boettcher linearization, Quadratic escape criterion, Sullivan''s no wandering domains, Fatou component classification, Straightening theorem
- **L5**: Complete — Induction on iteration (iterate_add, iterate_mul, iteration_commutes), Cases on multiplier classification (classifyMultiplier), Structural/categorical proofs (conjugacy invariants), Computable #eval verification
- **L6**: Complete — z², z²-1 (basilica), z²+i (dendrite), z²-2 (Chebyshev), Douady rabbit, z^d monomials, 1/z inversion, Newton basins, exponential family, Mandelbrot membership tests
- **L7**: Complete (3 applications) — Newton''s method for root finding (Cayley problem, Wada property), Population dynamics (logistic map, Feigenbaum universality, bifurcation diagram), Physics (renormalization group, CFT, quantum chaos, electrostatic equilibrium)
- **L8**: Partial (4 advanced topics) — Parabolic implosion (Ecalle cylinders, Lavaurs maps, Douady-Ecalle-Voronin), Renormalization (DH renormalization, McMullen tower, crossed/primitive/satellite), Transcendental dynamics (exponential family, Cantor bouquets, Speiser class, Baker domains, Eremenko conjecture), Several variables (Henon maps, polynomial automorphisms of C², Bedford-Diller renormalization)
- **L9**: Partial (8 research frontiers documented) — MLC conjecture, density of hyperbolicity, rigidity conjecture, Buff-Cheritat positive measure Julia sets, Siegel disk boundaries, transcendental wandering domains, mating conjecture, interdisciplinary connections (Kleinian groups, Teichmuller theory, number theory, physics)

## Structure

- **Core/** — RationalMap, iterate, PeriodicPoint, Multiplier, JuliaSet, FatouSet, MandelbrotSet, CriticalPoint, DynamicalSystem, Conjugacy, iteration laws, axiom system, object instances
- **Morphisms/** — DynamicalMorphism, MoebiusTransformation operations, HolomorphicConjugacy, LocalConjugacy, Koenigs/Boettcher isomorphisms, Automorphism group
- **Constructions/** — Product systems, skew products, quotient dynamics, orbit spaces, laminations, external rays, invariant subsets, polynomial-like maps, straightening theorem, moduli spaces
- **Properties/** — Topological entropy, Lyapunov exponents, Green''s function, harmonic measure, maximal entropy measure, conjugacy preservation, Fatou component classification (5 types), hyperbolic components, Hubbard trees, kneading sequences
- **Theorems/** — Fixed point theorems, Periodic point density, Fatou-Julia dichotomy, Complete invariance, Montel theory, Sullivan''s no wandering domains, Fatou component classification, Straightening, MLC conjecture statement, theorem tracking system
- **Examples/** — z², z²-1 (basilica), z²+i (dendrite), z²-2 (Chebyshev), Douady rabbit, Newton basins, exponential family, Cremer points, non-locally connected Julia sets, Cantor Julia sets, Sierpinski Julia sets, indecomposable continua
- **Bridges/** — Algebra (iterated monodromy groups, Galois), Topology (fundamental groups, ray landings, Caratheodory loop), Analysis (quasiconformal maps, potential theory, Sullivan dictionary), Geometry (hyperbolic metric, laminations), Computation (escape time, distance estimation, IFS)
- **Applications/** — Newton''s method (Cayley problem, basins, Wada property, relaxed Newton, Schroder method), Population dynamics (logistic map, Ricker, Hassell, Feigenbaum, bifurcation diagram), Physics (RG, CFT, quantum chaos, SLE, electrostatic equilibrium)
- **Advanced/** — Parabolic implosion (Ecalle cylinders, Lavaurs maps, horn maps, parabolic renormalization, Douady-Ecalle-Voronin), Renormalization (quadratic-like, simple/crossed/primitive/satellite, McMullen tower, infinitely renormalizable), Transcendental dynamics (exponential, Cantor bouquet, Speiser class, Baker domain, Eremenko conjecture), Several variables (Henon maps, polynomial automorphisms, C² and P² dynamics)
- **Frontiers/** — MLC conjecture, local connectivity, renormalization conjecture, density of hyperbolicity, Buff-Cheritat results, transcendental dynamics open problems

## Knowledge Coverage

| Level | Name | Status | Details |
|-------|------|--------|---------|
| L1 | Definitions | Complete | 30+ structure/inductive/def definitions |
| L2 | Core Concepts | Complete | 20+ theorems/lemmas |
| L3 | Math Structures | Complete | Fatou-Julia, axiom systems, moduli spaces |
| L4 | Fundamental Theorems | Complete | Fixed point, Fatou-Julia, invariance, Sullivan, etc. |
| L5 | Proof Techniques | Complete | Induction, cases, structural, #eval |
| L6 | Canonical Examples | Complete | 10+ standard examples with #eval |
| L7 | Applications | Complete (3) | Newton''s method, population dynamics, physics |
| L8 | Advanced Topics | Partial (4) | Parabolic implosion, renormalization, transcendental, several variables |
| L9 | Research Frontiers | Partial | 8 directions documented |

## Dependencies

- mini-object-kernel
- mini-axiom-kernel
- mini-complex-numbers
- mini-holomorphic-functions

## Build

```
lake build
```

## Test

```
lake env lean --run Test/Smoke.lean
lake env lean --run Test/Examples.lean
lake env lean --run Test/Regression.lean
```
