/-
# MiniComplexDynamics.Core.Objects

Object instances and theory registration for complex dynamics structures.
Registers dynamical objects in the MiniMathKernel ecosystem.

Knowledge coverage:
- L1: Object instances for JuliaSet, MandelbrotSet, RationalMap
- L2: Theory name hierarchy
- L3: Dynamical system object structure
- L6: #eval tests for object system
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Core.Laws
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics
open MiniComplexNumbers

namespace MiniComplexDynamics

/-! ## Object Instance for RationalMap -/

instance : Object RationalMap where
  theory := TheoryName.ofString "ComplexDynamics"
  objName := "RationalMap"
  repr r := s!"RationalMap(deg={r.degree})"

/-! ## Object Instance for JuliaSet -/

instance {f : ComplexNumbers -> ComplexNumbers} : Object (JuliaSet f) where
  theory := TheoryName.ofString "ComplexDynamics.JuliaSet"
  objName := "JuliaSet(f)"
  repr _ := "J(f)"

/-! ## Object Instance for MandelbrotSet -/

instance : Object MandelbrotSet where
  theory := TheoryName.ofString "ComplexDynamics.MandelbrotSet"
  objName := "MandelbrotSet"
  repr _ := "M"

/-! ## Object Instance for PeriodicPointType -/

instance : Object PeriodicPointType where
  theory := TheoryName.ofString "ComplexDynamics"
  objName := "PeriodicPointType"
  repr t := match t with
    | PeriodicPointType.superattracting => "superattracting"
    | PeriodicPointType.attracting => "attracting"
    | PeriodicPointType.neutral => "neutral"
    | PeriodicPointType.repelling => "repelling"

/-! ## Object Instance for MoebiusTransformation -/

instance : Object MoebiusTransformation where
  theory := TheoryName.ofString "ComplexDynamics"
  objName := "MoebiusTransformation"
  repr φ := s!"Mobius(a={repr φ.a}, b={repr φ.b}, c={repr φ.c}, d={repr φ.d})"

/-! ## Theory Registration -/

/-- Theory hierarchy for complex dynamics. -/
def dynamicsTheoryRoot : TheoryName :=
  TheoryName.ofString "ComplexDynamics"

def dynamicsTheoryIteration : TheoryName :=
  dynamicsTheoryRoot.extend "Iteration"

def dynamicsTheoryJuliaFatou : TheoryName :=
  dynamicsTheoryRoot.extend "JuliaFatouTheory"

def dynamicsTheoryMandelbrot : TheoryName :=
  dynamicsTheoryRoot.extend "MandelbrotTheory"

def dynamicsTheoryConjugacy : TheoryName :=
  dynamicsTheoryRoot.extend "ConjugacyTheory"

def dynamicsTheoryClassification : TheoryName :=
  dynamicsTheoryRoot.extend "Classification"

/-- Full theory hierarchy as a tree. -/
structure DynamicsTheoryHierarchy where
  root : TheoryName
  children : List TheoryName
  depth : Nat

/-- The hierarchy of complex dynamics theories. -/
def dynamicsHierarchy : DynamicsTheoryHierarchy := {
  root := dynamicsTheoryRoot
  children := [
    dynamicsTheoryIteration,
    dynamicsTheoryJuliaFatou,
    dynamicsTheoryMandelbrot,
    dynamicsTheoryConjugacy,
    dynamicsTheoryClassification
  ]
  depth := dynamicsTheoryRoot.depth + 1
}

/-! ## Dynamical System Registration -/

/-- Register a dynamical system. -/
def registerDynamicalSystem (sys : DynamicalSystem) : IO Unit := do
  IO.println s!"DynamicalSystem registered: degree={sys.degree}"
  IO.println s!"  Rational: {sys.isRational}"
  IO.println s!"  Critical points: {sys.criticalPointCount}"

/-- Get system information. -/
def systemInfo (sys : DynamicalSystem) : String :=
  s!"DynamicalSystem(deg={sys.degree}, rational={sys.isRational}, critPts={sys.criticalPointCount})"

/-! ## Canonical Object Instances -/

/-- The quadratic family as object instances. -/
def quadraticFamilyObjects (cValues : List ComplexNumbers) : List DynamicalSystem :=
  cValues.map fun c => quadraticSystem c

/-- Key examples for study. -/
def keyExamples : List (String × RationalMap) := [
  ("z^2", monomialMap 2),
  ("z^2 - 1", quadraticMap (ComplexNumbers.of (-1) 0)),
  ("z^2 + i", quadraticMap (ComplexNumbers.of 0 1)),
  ("z^2 - 2", quadraticMap (ComplexNumbers.of (-2) 0)),
  ("1/z", inversionMap)
]

/-- The Mandelbrot set as object. -/
def standardMandelbrotSet : MandelbrotSet := {
  isInSet := fun c => mandelbrotMembership c 200 2.0
  escapeRadius := 2.0
  maxIterations := 200
  boundedOrbitCondition := fun c => mandelbrotMembership c 200 2.0
  connectivityChar := true
  topologicalProperties := true
}

/-! ## #eval Tests -/

#eval "── Objects: Theory hierarchy ──"
#eval dynamicsTheoryRoot
#eval dynamicsTheoryIteration
#eval dynamicsTheoryJuliaFatou

#eval "── Objects: Object instances ──"
#eval describe RationalMap
#eval describe PeriodicPointType
#eval describe MandelbrotSet

#eval "── Objects: Key examples ──"
#eval keyExamples.map fun (name, _) => name

#eval "── Objects: System info ──"
#eval systemInfo (quadraticSystem (ComplexNumbers.of (-1) 0))
#eval systemInfo (quadraticSystem (ComplexNumbers.of 0 0))

end MiniComplexDynamics
