/-
# bifurcation_control_ref: Reference Implementation

Implementation and verification of bifurcation_control_ref concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== bifurcation_control_ref ==="
def fbifurcation_control_ref (x : Rat) : Rat := x/2
def dbifurcation_control_ref (x : Rat) : Rat := 1/2
def gbifurcation_control_ref : List Rat := List.map (fun i => (i:Rat)/10) (List.range 21)
#eval (List.filter (fun x => fbifurcation_control_ref x == x) gbifurcation_control_ref).length
#eval fixedPointCount fbifurcation_control_ref gbifurcation_control_ref
#eval periodicPointCount fbifurcation_control_ref gbifurcation_control_ref 1
#eval periodicPointCount fbifurcation_control_ref gbifurcation_control_ref 2
#eval periodicPointCount fbifurcation_control_ref gbifurcation_control_ref 3
#eval topologicalEntropyApprox fbifurcation_control_ref gbifurcation_control_ref 5
#eval topologicalEntropyApprox fbifurcation_control_ref gbifurcation_control_ref 10
#eval isStructurallyStable fbifurcation_control_ref dbifurcation_control_ref gbifurcation_control_ref
#eval polynomialCriticalPoints ({ coeffs := [0,0,1] } : Polynomial) gbifurcation_control_ref
#eval classifyCriticalPoint ({ coeffs := [0,0,1] } : Polynomial) 0
#eval periodicOrbitMultiplier fbifurcation_control_ref dbifurcation_control_ref 0 1
#eval periodicOrbitMultiplier fbifurcation_control_ref dbifurcation_control_ref 0 2
#eval isStructurallyStable1D fbifurcation_control_ref dbifurcation_control_ref [1,2,3,4] gbifurcation_control_ref
#eval birkhoffAverage fbifurcation_control_ref (fun x => x) 0 50
#eval birkhoffAverage fbifurcation_control_ref (fun x => x) 0 100
#eval isErgodicApprox fbifurcation_control_ref (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, 1+sqrtRat 6, ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## Structures and Types -/
def fambifurcation_control_ref : ParameterFamily Rat Rat := { f := fun mu x => x + mu }
#eval fambifurcation_control_ref.f 0 0
#eval fambifurcation_control_ref.f 1 0
#eval ParameterFamily.iterate fambifurcation_control_ref 1 5 0

def dsbifurcation_control_ref : DiscreteDS Rat := { f := fun x => x+1 }
#eval dsbifurcation_control_ref.iterate 0 0
#eval dsbifurcation_control_ref.iterate 5 0
#eval orbit dsbifurcation_control_ref.f 0 5

def polybifurcation_control_ref : Polynomial := { coeffs := [1, 0, 1] }
#eval polybifurcation_control_ref.eval 0
#eval polybifurcation_control_ref.eval 1
#eval polybifurcation_control_ref.eval (-1)
#eval polybifurcation_control_ref.derivAt 0
#eval polybifurcation_control_ref.derivAt 1
#eval polybifurcation_control_ref.derivAt (-1)

def poly2_bifurcation_control_ref : Polynomial := Polynomial.add polybifurcation_control_ref ({ coeffs := [0, 1] } : Polynomial)
#eval poly2_bifurcation_control_ref.eval 0
#eval poly2_bifurcation_control_ref.eval 1

def poly3_bifurcation_control_ref : Polynomial := Polynomial.sub ({ coeffs := [0,0,1] } : Polynomial) polybifurcation_control_ref
#eval poly3_bifurcation_control_ref.eval 0
#eval poly3_bifurcation_control_ref.eval 1

def poly4_bifurcation_control_ref : Polynomial := Polynomial.scalarMul 3 polybifurcation_control_ref
#eval poly4_bifurcation_control_ref.eval 0
#eval poly4_bifurcation_control_ref.eval 1

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

#eval "=== bifurcation_control_ref Complete ==="
