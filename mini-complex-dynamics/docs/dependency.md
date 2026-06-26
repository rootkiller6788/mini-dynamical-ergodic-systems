# Dependency Tree — MiniComplexDynamics

```
MiniComplexDynamics
  ├── mini-object-kernel (TheoryName, Object, Structure)
  ├── mini-axiom-kernel (Axiom, AxiomSet, AxiomSystem)
  ├── mini-complex-numbers (ComplexNumbers, modulus, arithmetic)
  └── mini-holomorphic-functions (isComplexDifferentiable, isHolomorphicOn, isEntire, SingularityType)
```

## Internal Dependency Graph
```
Core/Basic.lean
  ├── Core/Laws.lean
  ├── Core/Objects.lean
  ├── Morphisms/Hom.lean
  │   └── Morphisms/Equiv.lean
  │       └── Morphisms/Iso.lean
  ├── Constructions/Products.lean
  ├── Constructions/Quotients.lean
  ├── Constructions/Subobjects.lean
  ├── Constructions/Universal.lean
  ├── Properties/Invariants.lean
  │   ├── Properties/Preservation.lean
  │   └── Properties/ClassificationData.lean
  ├── Theorems/Basic.lean
  │   ├── Theorems/Classification.lean
  │   │   └── Theorems/Main.lean
  │   └── Theorems/UniversalProperties.lean
  ├── Examples/Standard.lean
  │   └── Examples/Counterexamples.lean
  ├── Bridges/*
  ├── Applications/*
  ├── Advanced/*
  └── Frontiers/ResearchFrontiers.lean
```
