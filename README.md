# Mini Dynamical & Ergodic Systems

A collection of **from-scratch, zero-dependency Lean 4 implementations** of university-level dynamical systems, ergodic theory, and bifurcation theory. Each sub-package maps to MIT (and other top-tier university) courses, building the qualitative theory of dynamical systems from first principles using the Lean 4 proof assistant.

## Sub-Packages

| Sub-Package | Topics | Key Courses |
|-------------|--------|-------------|
| [mini-ergodic-theory](mini-ergodic-theory/) | Ergodicity, mixing, Birkhoff, entropy, Kolmogorov-Sinai, Furstenberg correspondence | MIT 18.158, Princeton MAT 585 |
| [mini-topological-dynamics](mini-topological-dynamics/) | Topological entropy, expansiveness, Anosov diffeomorphisms, structural stability | MIT 18.158, Berkeley Math 242 |
| [mini-symbolic-dynamics](mini-symbolic-dynamics/) | Shift spaces, subshifts of finite type, entropy, zeta functions | MIT 18.158, Oxford Part C |
| [mini-bifurcation-theory](mini-bifurcation-theory/) | Local bifurcations, normal forms, center manifolds, chaos, Lyapunov exponents | MIT 18.385, Cambridge Part III |
| [mini-complex-dynamics](mini-complex-dynamics/) | Julia/Fatou sets, Mandelbrot, Montel/Carleman, quasiconformal surgery | MIT 18.158, Harvard Math 118 |
| [mini-hamiltonian-systems](mini-hamiltonian-systems/) | Hamiltonian mechanics, integrable systems, KAM theory, Arnold diffusion | MIT 18.385, Princeton MAT 585 |
| [mini-stability-theory](mini-stability-theory/) | Lyapunov stability, LaSalle invariance, input-to-state stability | MIT 18.385, Stanford AA 203 |
| [mini-random-dynamical-systems](mini-random-dynamical-systems/) | Random dynamical systems, multiplicative ergodic theorem, Lyapunov spectrum | MIT 18.158, Cambridge Part III |

## Design Philosophy

- **Zero external dependencies** -- pure Lean 4, only kernel imports
- **Self-contained sub-packages** -- each has its own `lakefile.lean`, Core/, Morphisms/, Constructions/, Properties/, Theorems/
- **Theory-to-code mapping** -- every module includes inline `#eval` examples and theorem statements

## Building

Each sub-package is standalone. Build with Lake:

```bash
cd mini-ergodic-theory
lake build
lake env lean --run Test/Smoke.lean
```

Requires **Lean 4** and **Lake**.

## Project Structure

```
18. mini-dynamical-ergodic-systems/
├── mini-ergodic-theory/            # Ergodicity, mixing, Birkhoff, entropy, Kolmogorov-Sinai
├── mini-topological-dynamics/      # Topological entropy, expansiveness, Anosov diffeomorphisms
├── mini-symbolic-dynamics/         # Shift spaces, subshifts of finite type, entropy, zeta functions
├── mini-bifurcation-theory/        # Local bifurcations, normal forms, center manifolds, chaos
├── mini-complex-dynamics/          # Julia/Fatou sets, Mandelbrot, quasiconformal surgery
├── mini-hamiltonian-systems/       # Hamiltonian mechanics, integrable systems, KAM theory
├── mini-stability-theory/          # Lyapunov stability, LaSalle invariance, input-to-state stability
├── mini-random-dynamical-systems/  # Random dynamical systems, multiplicative ergodic theorem
└── lakefile.lean
```

## License

MIT
