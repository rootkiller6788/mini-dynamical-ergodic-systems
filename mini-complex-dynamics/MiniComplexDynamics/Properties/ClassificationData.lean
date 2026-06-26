/-
# MiniComplexDynamics.Properties.ClassificationData

Classification data for complex dynamical systems:
Fatou component types, hyperbolic components,
and the dictionary between dynamics and combinatorics.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Properties.Invariants
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics

namespace MiniComplexDynamics

/-! ## Fatou Component Classification -/

/-- Sullivan's classification of Fatou components:
    A Fatou component is eventually periodic, and its cycle is one of:
    attracting basin, superattracting basin, parabolic basin,
    Siegel disk, or Herman ring. -/
inductive FatouComponentType
  | attractingBasin
  | superattractingBasin
  | parabolicBasin
  | siegelDisk
  | hermanRing
  deriving BEq, Inhabited, Repr

/-- A Fatou component with its type classification. -/
structure FatouComponent (f : ComplexNumbers -> ComplexNumbers) where
  domain : ComplexNumbers -> Bool
  componentType : FatouComponentType
  isConnected : Bool
  isOpen : Bool
  eventualPeriod : Nat
  isMaximal : Bool

/-- A Herman ring configuration. -/
structure HermanRingConfig (f : ComplexNumbers -> ComplexNumbers) where
  ringDomain : ComplexNumbers -> Bool
  isConformal : Bool
  rotationNumber : Float
  isIrrationalRotation : Bool

/-- A Siegel disk configuration. -/
structure SiegelDiskConfig (f : ComplexNumbers -> ComplexNumbers) where
  diskDomain : ComplexNumbers -> Bool
  fixedPoint : ComplexNumbers
  rotationNumber : Float
  isIrrational : Bool
  brjunoCondition : Bool

/-- A parabolic basin configuration. -/
structure ParabolicBasinConfig (f : ComplexNumbers -> ComplexNumbers) where
  parabolicPoint : ComplexNumbers
  basinCount : Nat
  numberOfPetals : Nat
  attractionDirections : List Float

/-! ## Hyperbolic Components -/

/-- A rational map is hyperbolic if every critical point converges
    to an attracting cycle. -/
structure HyperbolicMap (f : RationalMap) where
  allCriticalPointsAttracted : Bool
  juliaSetExpanding : Bool
  structurallyStable : Bool

/-- A hyperbolic component in parameter space. -/
structure HyperbolicComponent where
  parameters : ComplexNumbers -> Bool
  period : Nat
  attractingCycle : List ComplexNumbers
  isConnected : Bool
  root : ComplexNumbers

/-- The Mandelbrot set has a dense set of hyperbolic components. -/
structure HyperbolicDensity where
  hyperbolicComponentsDense : Bool

/-! ## Combinatorial Classification -/

/-- Hubbard tree: a finite invariant tree in the filled Julia set. -/
structure HubbardTree (f : ComplexNumbers -> ComplexNumbers) where
  vertices : List ComplexNumbers
  edges : List (ComplexNumbers × ComplexNumbers)
  isInvariant : Bool
  containsCriticalOrbit : Bool
  isTree : Bool

/-- Kneading sequence: the itinerary of the critical value. -/
structure KneadingSequence where
  symbols : List Nat
  criticalItinerary : List Nat
  determinesDynamics : Bool

/-- External angles and landing points. -/
structure ExternalAngleLanding where
  angle : Float
  landingPoint : ComplexNumbers
  isPeriodic : Bool
  isRational : Bool

/-- Matings of polynomials: gluing two filled Julia sets. -/
structure Mating (p q : ComplexNumbers -> ComplexNumbers) where
  formalMating : ComplexNumbers -> ComplexNumbers
  topologicalMating : Bool
  isRational : Bool

/-- The dictionary from dynamics to combinatorics. -/
structure DynamicsToCombinatorics where
  kneadingDesc : String
  hubbardTreeDesc : String
  laminationDesc : String
  externalRayCount : Nat

/-! ## #eval -/

#eval "── Classification: Fatou component types ──"
#eval repr FatouComponentType.attractingBasin
#eval repr FatouComponentType.siegelDisk
#eval repr FatouComponentType.hermanRing

end MiniComplexDynamics
