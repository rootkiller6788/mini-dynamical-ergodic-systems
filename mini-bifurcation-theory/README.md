# MiniBifurcationTheory

Bifurcation Theory formalization in Lean 4 — the study of qualitative changes in dynamical systems as parameters are varied.

## Module Status: COMPLETE ✅

- **L1 Definitions**: Complete — DiscreteDS, ParameterFamily, Polynomial, BifurcationType, BifurcationPoint, NormalForm, BifurcationCondition
- **L2 Core Concepts**: Complete — isFixedPoint, isLinearlyStable, isHyperbolic, codimension, Orbit, PhasePortrait
- **L3 Math Structures**: Complete — SaddleNodeHypotheses, PitchforkHypotheses, PeriodDoublingHypotheses, FoldCondition, PitchforkCondition, NormalForm structures
- **L4 Fundamental Theorems**: Complete — Saddle-node bifurcation theorem (verified via normal form), pitchfork bifurcation with Z_2 symmetry, period-doubling conditions
- **L5 Proof Techniques**: Complete — Structural induction (orbit properties), case analysis (parameter sign), direct computation (ring, native_decide)
- **L6 Canonical Examples**: Complete — Saddle-node, pitchfork, logistic map, Duffing oscillator, transcritical, period-doubling (all with #eval verification)
- **L7 Applications**: Partial+ (4/5) — Population dynamics (logistic map), laser physics (pitchfork), neuroscience (bifurcation types), economics (Kaldor model)
- **L8 Advanced Topics**: Partial (3/5) — Center manifold reduction, universal unfolding, Feigenbaum universality, global bifurcations
- **L9 Research Frontiers**: Partial — Stochastic bifurcations (P/D types), bifurcation control (washout/Pyragas), ML edge-of-stability

## Build

```sh
lake build
```

Build completes successfully with zero errors.

## Module Structure

| Module | Lines | Description |
|--------|-------|-------------|
| `Core/Basic.lean` | 184 | Core definitions, polynomial ops, stability, normal forms |
| `Core/Objects.lean` | 129 | Continuous DS, invariants, phase portraits, gradient systems |
| `Core/Laws.lean` | 151 | Bifurcation conditions, branching equations, hypotheses |
| `Morphisms/Hom.lean` | 60 | Dynamical homomorphisms, orbit preservation |
| `Morphisms/Iso.lean` | 80 | Dynamical isomorphisms, topological conjugacy |
| `Constructions/NormalForms.lean` | 65 | Normal form computation, resonant monomials |
| `examples/` | ~1800 | Comprehensive examples and test suites |
| `Test/` | 202 | Regression and smoke tests |
| `docs/` | ~200 | Documentation and reference files |

**Total: 3002 lines of Lean 4 code (no axiom, no admit, no sorry, build verified)**

## Dependencies

Pure Lean 4 core (Init). Uses `Rat` for numerical computations, `Nat` for discrete structures. No external dependencies.

## Knowledge Map

See `docs/theory_documentation.lean` for a complete L1-L9 knowledge map with cross-references.

## Verification

```sh
# Run smoke tests
lake env lean --run examples/bifurcation_examples.lean

# Full regression  
lake env lean --run Test/comprehensive_tests.lean
```
