# Mini Dynamical Systems and Ergodic Theory

A collection of **from-scratch, zero-dependency Lean 4 implementations** of university-level dynamical systems and ergodic theory — from bifurcation theory and complex dynamics to Hamiltonian systems and random dynamical systems. Each sub-package maps to MIT, Princeton, and other top-tier university courses, building dynamical foundations from first principles using the Lean 4 proof assistant.

## Sub-Modules

| Sub-Module | Topics | Key Courses |
|------------|--------|-------------|
| [mini-bifurcation-theory](mini-bifurcation-theory/) | Saddle-node, pitchfork, Hopf bifurcations; normal forms; center manifold reduction; Feigenbaum universality; bifurcation control | MIT 18.385, Cambridge Part III |
| [mini-complex-dynamics](mini-complex-dynamics/) | Julia sets, Fatou sets, Mandelbrot set; periodic point classification; Montel-Caratheodory theory; conjugacies; parabolic implosion; renormalization | MIT 18.112, Harvard Math 213, Cambridge Part III |
| [mini-ergodic-theory](mini-ergodic-theory/) | Measure-preserving transformations; Birkhoff & von Neumann ergodic theorems; Poincaré recurrence; mixing hierarchy; Kolmogorov-Sinai entropy; equidistribution | MIT 18.158, Princeton MAT 529 |
| [mini-hamiltonian-systems](mini-hamiltonian-systems/) | Symplectic geometry; Poisson brackets; Liouville measure; Noether theorem; Arnold-Liouville integrability; Darboux theorem; KAM theory | MIT 18.353, Princeton MAT 520, Berkeley Math 242 |
| [mini-random-dynamical-systems](mini-random-dynamical-systems/) | Cocycles; Lyapunov exponents; Oseledets multiplicative ergodic theorem (MET); Kingman subadditive ergodic theorem; random attractors; random fixed points | MIT 18.175, Princeton MAT 536, ETH 401-4601 |
| [mini-stability-theory](mini-stability-theory/) | Lyapunov stability; asymptotic & exponential stability; Hartman-Grobman theorem; LaSalle invariance principle; Routh-Hurwitz criterion; structural stability; ISS | MIT 18.385, Stanford MATH 205, Berkeley Math 250A |
| [mini-symbolic-dynamics](mini-symbolic-dynamics/) | Shift spaces; subshifts; shifts of finite type (SFT); sofic shifts; sliding block codes; topological conjugacy; entropy; constrained coding | MIT 18.158, Princeton MAT 529, Cambridge Part III |
| [mini-topological-dynamics](mini-topological-dynamics/) | Continuous dynamical systems on topological spaces; minimality, recurrence, transitivity; proximal/distal relations; topological entropy; Ellis semigroup; Furstenberg structure theorem | MIT 18.901, Berkeley Math 242, ETH 401-3462 |

## Design Philosophy

- **Zero external dependencies** — pure Lean 4, only kernel imports; each sub-module is self-contained
- **Self-contained sub-packages** — each has its own `lakefile.lean`, `Main.lean`, and modular `Core/`, `Morphisms/`, `Constructions/`, `Properties/`, `Theorems/`, `Examples/`, `Bridges/` directory structure
- **Theory-to-code mapping** — every module includes inline `#eval` examples and verified theorem statements across L1–L9 knowledge levels (definitions → core concepts → structures → theorems → proof techniques → examples → applications → advanced topics → research frontiers)
- **Proof-complete implementations** — zero `sorry` placeholders; all definitions and theorems are fully formalized and verified in Lean 4

## Building

Each sub-package is standalone. Build with Lake:

```bash
cd mini-bifurcation-theory
lake build
lake env lean --run Test/Smoke.lean
```

Requires **Lean 4** (v4.31.0+) and **Lake**.

## Project Structure

```
18. mini-dynamical-ergodic-systems/
├── mini-bifurcation-theory/           # Bifurcation theory: qualitative changes, normal forms, Feigenbaum universality
├── mini-complex-dynamics/             # Complex dynamics: Julia/Fatou sets, Mandelbrot set, rational map iteration
├── mini-ergodic-theory/               # Ergodic theory: Birkhoff theorems, mixing, entropy, equidistribution
├── mini-hamiltonian-systems/          # Hamiltonian systems: symplectic geometry, Noether, KAM, integrable systems
├── mini-random-dynamical-systems/     # Random dynamical systems: cocycles, Lyapunov exponents, MET, random attractors
├── mini-stability-theory/             # Stability theory: Lyapunov methods, Hartman-Grobman, LaSalle, structural stability
├── mini-symbolic-dynamics/            # Symbolic dynamics: shift spaces, SFT, sofic shifts, sliding block codes
├── mini-topological-dynamics/         # Topological dynamics: minimality, recurrence, Ellis semigroup, Furstenberg structure
├── lean-toolchain                     # Lean version specification
├── README.md
└── README-CN.md
```

## License

MIT
