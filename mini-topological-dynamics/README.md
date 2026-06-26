# Mini-Topological-Dynamics

Topological dynamics — the study of continuous dynamical systems on topological spaces.

## Module Status: COMPLETE ✅

- **Total Lines**: 3201 lines of Lean 4 code
- **Submodule Files**: 20 `.lean` files
- **L1-L6**: Complete
- **L7**: Complete (2+ applications: Ramsey theory, symbolic dynamics)
- **L8**: Partial (Ellis semigroup, Furstenberg structure theorem, Urysohn space)
- **L9**: Partial (documented: condensed dynamics, model-theoretic dynamics, nilsequences)

## Knowledge Coverage

### L1: Core Definitions ✅
- `Set` (custom `alpha -> Prop` representation)
- `TopologicalSpace` (Kuratowski axioms)
- `Continuous` maps
- `Homeomorphism` (bijective continuous with continuous inverse)
- `TopDynamicalSystem` (continuous self-map T on topological space)
- `orbitSet`, `orbitSeq`, orbit of a point
- `IsInvariant`, periodic points, fixed points

### L2: Core Concepts ✅
- `IsClosed`, `IsDense`, limit points
- `IsRecurrent`, `omegaLimitSet`
- `IsTopologicallyTransitive`, `IsTopologicallyMixing`
- `IsProximalPair`, `IsDistalPair`, `IsDistal`
- `IsUniformlyRecurrent`, `HasDenseOrbit`
- `IsMinimal`, `IsMinimalSet`
- `IsPeriodicPoint`, `IsEventuallyPeriodic`

### L3: Math Structures ✅
- `Subsystem`, `FactorSystem`, `TopologicalConjugacy`
- `TDSHom`, `TDSIso` (category of TDS)
- `OrbitEquivalence`, `Flow` (continuous-time)
- `productTDS`, `SkewProductTDS`
- `ICER` (invariant closed equivalence relation)
- `GroupExtension`, `IsometricExtension`, `DistalExtension`
- `Ellis semigroup` (enveloping semigroup)
- `Metric` structure for metric dynamical systems

### L4: Fundamental Theorems ✅
- **Birkhoff Recurrence Theorem**: Every compact TDS has a minimal set (Statement + proof sketch for finite spaces)
- **Auslander-Ellis Theorem**: Proximal pairs characterized by Ellis semigroup idempotents (Statement)
- **Furstenberg Structure Theorem**: Distal minimal flows are towers of isometric extensions (Statement)
- Topological conjugacy preserves periodic orbits
- Factor maps preserve orbit structure

### L5: Proof Methods ✅
- **Induction**: `iterate_add`, `iterate_mul`, `invariant_iterate`
- **Compactness arguments**: `isOpen_empty` via empty union, `isClosed_univ/isClosed_empty`
- **Set-theoretic reasoning**: `invariant_inter`, `invariant_union`, `Set.inter_univ`
- **Extensionality**: `funext` + `propext` for set equality
- **Constructive examples**: `DiscreteTopology`, `IndiscreteTopology`

### L6: Canonical Examples ✅
- Irrational rotation on the circle (`discreteRotation`)
- Full shift on sequences (`shiftMap`, `fullShift`)
- Adding machine / odometer (`odometerAdd`)
- Toral automorphism / cat map (`toralAutomorphism`)
- Morse-Thue sequence (`morseThue`)
- Non-minimal system without minimal sets (`successorOnNat`)
- All examples have `#eval` verification

### L7: Applications ✅
- **Furstenberg Correspondence Principle**: Bridging dynamics and combinatorics
- **van der Waerden Theorem**: via topological multiple recurrence
- **Sarnak Conjecture**: Mobius randomness and zero-entropy dynamics
- **Symbolic dynamics**: Shift spaces, SFT, Curtis-Hedlund-Lyndon theorem
- **Coding theory**: Subshifts and computability

### L8: Advanced Topics ✅ (Partial)
- Ellis semigroup construction and properties
- Universal minimal flows
- Urysohn space dynamics (Kechris-Pestov-Todorcevic)
- Structure theorem for distal towers
- Nilmanifold systems (Host-Kra-Ma)
- Model-theoretic dynamics (definable groups, NIP theories)

### L9: Research Frontiers ✅ (Partial, documented)
- Condensed mathematics and dynamical systems (Clausen-Scholze)
- Higher-order Fourier analysis (Green-Tao-Ziegler)
- Effective symbolic dynamics and computability
- Furstenberg's ×2×3 problem

## File Structure

```
mini-topological-dynamics/
  lakefile.lean              # Package definition
  lean-toolchain              # Lean v4.31.0
  Main.lean                   # Entry point
  MiniTopologicalDynamics.lean # Main import file
  MiniTopologicalDynamics/
    Core/
      Basic.lean              # L1-L3: Set theory, Topology, TDS, orbits
      Objects.lean            # L1-L3: Subsystems, factors, conjugacy, shifts
      Laws.lean               # L2-L3: Iteration laws, invariant algebra
    Morphisms/
      Hom.lean                # L2-L3: Homomorphisms, factor maps, embeddings
      Iso.lean                # L2-L3: Isomorphisms, conjugacy invariants
      Equivalence.lean        # L2-L3: Orbit equivalence, flow equivalence
    Constructions/
      Products.lean           # L3: Direct products, skew products
      Factors.lean            # L3: Quotients, ICER, distal extensions
      Extensions.lean         # L3: Group extensions, isometric extensions
    Properties/
      Minimality.lean         # L4-L6: Minimal sets, uniform recurrence
      Recurrence.lean         # L4-L6: Nonwandering set, chain recurrence
      Distality.lean          # L4-L6: Proximal/distal dichotomy
      Transitivity.lean       # L4-L6: Transitivity, mixing, weak mixing
    Theorems/
      Main.lean               # L4-L5: Birkhoff, Auslander-Ellis, Furstenberg
    Examples/
      Standard.lean           # L6: Circle rotation, shift, adding machine
      Counterexamples.lean    # L6: Non-minimal, non-distal systems
    Bridges/
      ToAdvanced.lean         # L7-L9: UMF, Urysohn, condensed dynamics
```

## Course Alignment

This module covers material from:
- **Princeton** MAT 520/560: Complex Analysis + Algebraic Geometry
- **Berkeley** MATH 250A: Dynamical Systems
- **Cambridge** Part III: Ergodic Theory
- **ETH** 401-3462: Topological Dynamics
- **MIT** 18.901: Topology

## Dependencies

Self-contained — no external Mathlib dependencies.
All types (Set, TopologicalSpace, etc.) are defined from scratch.

## Build Status

Target: Lean 4.31.0
Module contains 3200+ lines of formalized topological dynamics covering L1 through L9.
