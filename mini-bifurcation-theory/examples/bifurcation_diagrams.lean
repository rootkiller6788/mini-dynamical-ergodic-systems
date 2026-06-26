/-
# bifurcation_diagrams: Extended Bifurcation Reference

Comprehensive reference for bifurcation_diagrams.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== bifurcation_diagrams ==="
def fbifurcation_diagrams (x : Rat) : Rat := x + (1:Rat)/10 - x*x
def dbifurcation_diagrams (x : Rat) : Rat := 1 - 2*x
def gbifurcation_diagrams : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
#eval (List.filter (fun x => fbifurcation_diagrams x == x) gbifurcation_diagrams).length
#eval fixedPointCount fbifurcation_diagrams gbifurcation_diagrams
#eval periodicPointCount fbifurcation_diagrams gbifurcation_diagrams 1
#eval periodicPointCount fbifurcation_diagrams gbifurcation_diagrams 2
#eval topologicalEntropyApprox fbifurcation_diagrams gbifurcation_diagrams 10
#eval isStructurallyStable fbifurcation_diagrams dbifurcation_diagrams gbifurcation_diagrams
#eval polynomialCriticalPoints ({ coeffs := [0, 1, -1] } : Polynomial) gbifurcation_diagrams
#eval classifyCriticalPoint ({ coeffs := [0, 1, -1] } : Polynomial) ((1:Rat)/2)
#eval periodicOrbitMultiplier fbifurcation_diagrams dbifurcation_diagrams 0 1
#eval isStructurallyStable1D fbifurcation_diagrams dbifurcation_diagrams [1,2] gbifurcation_diagrams
#eval birkhoffAverage fbifurcation_diagrams (fun x => x) 0 100
#eval isErgodicApprox fbifurcation_diagrams (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, (1+sqrtRat 6), ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## bifurcation_diagrams Additional Checks -/
def fambifurcation_diagrams : ParameterFamily Rat Rat := { f := fun mu x => x + mu - x*x }
#eval fambifurcation_diagrams.f 0 0
#eval ParameterFamily.iterate fambifurcation_diagrams ((1:Rat)/4) 10 0

def dsbifurcation_diagrams : DiscreteDS Rat := { f := fun x => 2*x }
#eval dsbifurcation_diagrams.iterate 0 1
#eval dsbifurcation_diagrams.iterate 5 1
#eval orbit dsbifurcation_diagrams.f 1 5

def polybifurcation_diagrams : Polynomial := { coeffs := [0, 1, 0, -1] }
#eval polybifurcation_diagrams.eval 0
#eval polybifurcation_diagrams.eval 1
#eval polybifurcation_diagrams.eval 2
#eval polybifurcation_diagrams.derivAt 0
#eval polybifurcation_diagrams.derivAt 1

#eval codimension .saddleNode
#eval codimension .periodDoubling
#eval codimension .hopf
#eval codimension .transcritical
#eval codimension (.pitchfork true)

#eval "=== bifurcation_diagrams Complete ==="
