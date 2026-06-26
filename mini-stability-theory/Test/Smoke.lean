/-
# Stability Theory: Smoke Tests
Quick type-checking verification.
-/
import MiniStabilityTheory
open MiniStabilityTheory

#eval DiscreteSystem.mk (fun (x : Float) => x*x) |>.step 3.0
#eval DiscreteSystem.mk (fun (x : Float) => 2.0*x) |>.iterate 5 1.0
#eval orbit (fun (x : Float) => x + 1.0) 0.0 5

#eval StabilityType.stableNode.isStable; #eval StabilityType.saddle.isStable
#eval StabilityType.center.isHyperbolic; #eval StabilityType.stableFocus.isHyperbolic

def testSys : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
#eval testSys.trace; #eval testSys.det; #eval testSys.discriminant
#eval testSys.eigenvalues; #eval testSys.classify; #eval testSys.isStable

#eval isHurwitzQuadratic 3.0 2.0; #eval isHurwitzQuadratic (-1.0) 2.0
#eval isHurwitzCubic 5.0 8.0 3.0; #eval juryStability2D 0.5 0.2

#eval logisticMap 2.5 0.6; #eval logisticDeriv 2.5 0.6

#eval cubicLyapunovV 2.0; #eval cubicLyapunovVDot 2.0
#eval harmonicEnergy 2.0 1.0 0.0; #eval pendulumEnergy 9.8 1.0 pi 0.0

def stableNode : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
def saddle : LinearSystem2D := { a11 := 1.0, a12 := 2.0, a21 := 3.0, a22 := -1.0 }
def stableFocus : LinearSystem2D := { a11 := -1.0, a12 := 2.0, a21 := -2.0, a22 := -1.0 }
def center : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -4.0, a22 := 0.0 }
def unstableNode : LinearSystem2D := { a11 := 2.0, a12 := 0.0, a21 := 0.0, a22 := 3.0 }
#eval stableNode.classify; #eval saddle.classify; #eval stableFocus.classify
#eval center.classify; #eval unstableNode.classify

def charPoly : CharPoly := { coeffs := [2.0, 3.0] }
#eval charPoly.isStableRouthHurwitz2

#eval spectralAbscissa2D testSys; #eval stabilityIndex testSys; #eval morseIndex2D testSys

#eval "All smoke tests passed!"
/-! ## Extended Smoke Tests -/

/-- Test all stability type classifications. -/
def stabilityTypeTests : List (StabilityType * Bool) := [
  (.saddle, false), (.unstableNode, false), (.unstableFocus, false),
  (.center, false), (.stableNode, true), (.stableFocus, true), (.degenerate, false)
]
#eval stabilityTypeTests.map (fun (s, e) => s.isStable == e) |>.all id

/-- Test all 2D classification cases. -/
#eval classifyByTraceDet (-3.0) 2.0 == .stableNode
#eval classifyByTraceDet (-1.0) 5.0 == .stableFocus
#eval classifyByTraceDet (0.0) 4.0 == .center
#eval classifyByTraceDet (3.0) 2.0 == .unstableNode
#eval classifyByTraceDet (1.0) (-1.0) == .saddle

/-- Test eigenvalue computations. -/
def testEigSys : LinearSystem2D := { a11 := -2.0, a12 := 0.0, a21 := 0.0, a22 := -3.0 }
#eval testEigSys.eigenvalues
#eval testEigSys.trace
#eval testEigSys.det

/-- Test Lyapunov equation check. -/
def testA : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
def testP : LinearSystem2D := { a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 }
def testQ : LinearSystem2D := { a11 := 4.0, a12 := -1.0, a21 := -1.0, a22 := 6.0 }
#eval checkLyapunovEq testA testP testQ

/-- Test stability margin computations. -/
#eval dampingRatio testA
#eval naturalFrequency testA
#eval spectralAbscissa2D testA
#eval stabilityIndex testA

/-- Test logistic computations. -/
#eval logisticMap 3.5 0.5
#eval logisticMap 3.5 (logisticMap 3.5 0.5)
#eval logisticDeriv 3.5 0.5

/-- Test orbit computation. -/
#eval orbit (fun x => 2.0*x) 1.0 4
#eval orbit (fun x => x*x) 2.0 3

/-- Test polynomial evaluation. -/
#eval evalPoly [1.0, 2.0, 3.0] 0.0
#eval evalPoly [1.0, 2.0, 3.0] 1.0

/-- Test energy functions. -/
#eval harmonicEnergy 2.0 0.0 1.0
#eval harmonicEnergy 2.0 1.0 0.0
#eval pendulumEnergy 9.8 1.0 0.5 0.0

/-- Test numerical method stability. -/
#eval eulerStabilityLimit 10.0 0.05
#eval eulerStabilityLimit 10.0 0.25
#eval implicitEulerStabilityLimit 10.0 0.5

/-- Test control design checks. -/
#eval pidStabilityCheck 1.0 0.5 0.1 1.0 1.0
#eval quadraticLossStability 0.05
#eval quadraticLossStability 2.5

/-- Test time-domain responses. -/
#eval firstOrderStepResponse 1.0 1.0 0.0
#eval firstOrderStepResponse 1.0 1.0 1.0
#eval firstOrderStepResponse 1.0 1.0 5.0

/-- Test discrete system convergence. -/
def testDiscreteSys : DiscreteSystem Float := { step := fun x => 0.5*x }
#eval testDiscreteSys.iterate 10 1.0
#eval testDiscreteSys.iterate 20 1.0

/-- Test stability of different configurations. -/
#eval vanDerPol 1.0 |>.toFirstOrder 2.0 0.0
#eval vanDerPol 2.0 |>.toFirstOrder 0.5 0.5
#eval duffing 1.0 (-1.0) 0.2 |>.toFirstOrder 0.5 0.5

/-- Test spectral computations. -/
#eval spectralRadius2D ({ a11 := 0.5, a12 := 0.0, a21 := 0.0, a22 := 0.3 } : LinearDiscreteSystem2D)
#eval juryStability2D 0.5 0.2
#eval isSchurStableQuadratic 0.5 0.3

/-- Test detection of stability changes. -/
#eval detectStabilityChange (-1.0) 2.0 (-2.0) 2.0
#eval detectStabilityChange (-1.0) 2.0 2.0 2.0

/-- Test robust stability checks. -/
#eval checkCircleCriterion testA 0.0 10.0
#eval checkPopovCriterion testA 1.0 0.1

#eval "Extended smoke tests complete!"
