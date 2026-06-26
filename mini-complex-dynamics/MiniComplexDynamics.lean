/-
# MiniComplexDynamics — Complex Dynamics in Lean 4

Theory of iteration of rational maps on the Riemann sphere ℂ̂ = ℂ ∪ {∞}.
Covers: Julia sets, Fatou sets, Mandelbrot set, periodic points,
multiplier classification, conjugacies, Montel-Caratheodory theory,
Fatou component classification, and advanced topics.

## Knowledge Coverage

- L1: RationalMap, JuliaSet, FatouSet, MandelbrotSet, PeriodicPoint
- L2: isRational, isAttracting/isRepelling/isNeutral, conjugacy
- L3: DynamicalSystem, ParameterSpace, IterationSemigroup
- L4: Fixed Point Classification, Fatou-Julia Dichotomy
- L5: Induction on iteration, cases analysis, contraction argument
- L6: Standard examples with #eval
- L7: Newton's method, population dynamics, cryptography
- L8: Parabolic implosion, renormalization, transcendental dynamics
- L9: MLC conjecture, local connectivity, research frontiers
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniComplexDynamics.Core.Objects
import MiniComplexDynamics.Morphisms.Hom
import MiniComplexDynamics.Morphisms.Equiv
import MiniComplexDynamics.Morphisms.Iso
import MiniComplexDynamics.Constructions.Products
import MiniComplexDynamics.Constructions.Quotients
import MiniComplexDynamics.Constructions.Subobjects
import MiniComplexDynamics.Constructions.Universal
import MiniComplexDynamics.Properties.Invariants
import MiniComplexDynamics.Properties.Preservation
import MiniComplexDynamics.Properties.ClassificationData
import MiniComplexDynamics.Theorems.Basic
import MiniComplexDynamics.Theorems.Classification
import MiniComplexDynamics.Theorems.Main
import MiniComplexDynamics.Theorems.UniversalProperties
import MiniComplexDynamics.Examples.Standard
import MiniComplexDynamics.Examples.Counterexamples
import MiniComplexDynamics.Bridges.ToAlgebra
import MiniComplexDynamics.Bridges.ToTopology
import MiniComplexDynamics.Bridges.ToAnalysis
import MiniComplexDynamics.Bridges.ToGeometry
import MiniComplexDynamics.Bridges.ToComputation
import MiniComplexDynamics.Applications.NewtonMethod
import MiniComplexDynamics.Applications.PopulationDynamics
import MiniComplexDynamics.Applications.PhysicsApplications
import MiniComplexDynamics.Advanced.ParabolicImplosion
import MiniComplexDynamics.Advanced.Renormalization
import MiniComplexDynamics.Advanced.TranscendentalDynamics
import MiniComplexDynamics.Advanced.SeveralVariables
import MiniComplexDynamics.Frontiers.ResearchFrontiers
