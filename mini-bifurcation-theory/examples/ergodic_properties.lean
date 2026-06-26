/-
# ergodic_properties: Reference Implementation

Implementation and verification of ergodic_properties concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== ergodic_properties ==="
def fergodic_properties (x : Rat) : Rat := x/2
def dergodic_properties (x : Rat) : Rat := 1/2
def gergodic_properties : List Rat := List.map (fun i => (i:Rat)/10) (List.range 21)
#eval (List.filter (fun x => fergodic_properties x == x) gergodic_properties).length
#eval fixedPointCount fergodic_properties gergodic_properties
#eval periodicPointCount fergodic_properties gergodic_properties 1
#eval periodicPointCount fergodic_properties gergodic_properties 2
#eval periodicPointCount fergodic_properties gergodic_properties 3
#eval topologicalEntropyApprox fergodic_properties gergodic_properties 5
#eval topologicalEntropyApprox fergodic_properties gergodic_properties 10
#eval isStructurallyStable fergodic_properties dergodic_properties gergodic_properties
#eval polynomialCriticalPoints ({ coeffs := [0,0,1] } : Polynomial) gergodic_properties
#eval classifyCriticalPoint ({ coeffs := [0,0,1] } : Polynomial) 0
#eval periodicOrbitMultiplier fergodic_properties dergodic_properties 0 1
#eval periodicOrbitMultiplier fergodic_properties dergodic_properties 0 2
#eval isStructurallyStable1D fergodic_properties dergodic_properties [1,2,3,4] gergodic_properties
#eval birkhoffAverage fergodic_properties (fun x => x) 0 50
#eval birkhoffAverage fergodic_properties (fun x => x) 0 100
#eval isErgodicApprox fergodic_properties (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, 1+sqrtRat 6, ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## Structures and Types -/
def famergodic_properties : ParameterFamily Rat Rat := { f := fun mu x => x + mu }
#eval famergodic_properties.f 0 0
#eval famergodic_properties.f 1 0
#eval ParameterFamily.iterate famergodic_properties 1 5 0

def dsergodic_properties : DiscreteDS Rat := { f := fun x => x+1 }
#eval dsergodic_properties.iterate 0 0
#eval dsergodic_properties.iterate 5 0
#eval orbit dsergodic_properties.f 0 5

def polyergodic_properties : Polynomial := { coeffs := [1, 0, 1] }
#eval polyergodic_properties.eval 0
#eval polyergodic_properties.eval 1
#eval polyergodic_properties.eval (-1)
#eval polyergodic_properties.derivAt 0
#eval polyergodic_properties.derivAt 1
#eval polyergodic_properties.derivAt (-1)

def poly2_ergodic_properties : Polynomial := Polynomial.add polyergodic_properties ({ coeffs := [0, 1] } : Polynomial)
#eval poly2_ergodic_properties.eval 0
#eval poly2_ergodic_properties.eval 1

def poly3_ergodic_properties : Polynomial := Polynomial.sub ({ coeffs := [0,0,1] } : Polynomial) polyergodic_properties
#eval poly3_ergodic_properties.eval 0
#eval poly3_ergodic_properties.eval 1

def poly4_ergodic_properties : Polynomial := Polynomial.scalarMul 3 polyergodic_properties
#eval poly4_ergodic_properties.eval 0
#eval poly4_ergodic_properties.eval 1

#eval codimension .saddleNode
#eval codimension .transcritical
#eval codimension (.pitchfork true)
#eval codimension (.pitchfork false)
#eval codimension .periodDoubling
#eval codimension .hopf

#eval normalFormSaddleNode.bType
#eval normalFormTranscritical.bType
#eval normalFormPitchforkSuper.bType
#eval normalFormPitchforkSub.bType
#eval normalFormPeriodDoubling.bType

#eval "=== ergodic_properties Complete ==="
