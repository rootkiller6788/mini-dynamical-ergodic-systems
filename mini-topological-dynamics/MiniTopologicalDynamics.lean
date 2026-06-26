/-
# MiniTopologicalDynamics

Topological Dynamics — the study of continuous dynamical systems on topological spaces.

Key topics:
- Topological Dynamical Systems (continuous maps on topological spaces)
- Minimality, recurrence, and transitivity
- Proximal and distal relations
- Topological entropy
- Ellis semigroup and universal minimal flows
- Furstenberg structure theorem for distal flows

## Sub-packages
- `Core`          — Basic definitions: TopologicalSpace, TDS, orbits, invariant sets
- `Morphisms`     — Homomorphisms, isomorphisms, conjugacies, equivalences
- `Constructions` — Products, factors, extensions, inverse limits
- `Properties`    — Minimality, recurrence, distality, transitivity, entropy
- `Theorems`      — Birkhoff recurrence, Auslander-Ellis, Furstenberg structure
- `Examples`      — Standard examples: irrational rotation, shift, adding machine
- `Bridges`       — Applications to Ramsey theory, advanced topics
-/

import MiniTopologicalDynamics.Core.Basic
import MiniTopologicalDynamics.Core.Objects
import MiniTopologicalDynamics.Core.Laws
import MiniTopologicalDynamics.Morphisms.Hom
import MiniTopologicalDynamics.Morphisms.Iso
import MiniTopologicalDynamics.Morphisms.Equivalence
import MiniTopologicalDynamics.Constructions.Products
import MiniTopologicalDynamics.Constructions.Factors
import MiniTopologicalDynamics.Constructions.Extensions
import MiniTopologicalDynamics.Properties.Minimality
import MiniTopologicalDynamics.Properties.Recurrence
import MiniTopologicalDynamics.Properties.Distality
import MiniTopologicalDynamics.Properties.Transitivity
import MiniTopologicalDynamics.Theorems.Main
import MiniTopologicalDynamics.Examples.Standard
import MiniTopologicalDynamics.Examples.Counterexamples
import MiniTopologicalDynamics.Bridges.ToAdvanced
