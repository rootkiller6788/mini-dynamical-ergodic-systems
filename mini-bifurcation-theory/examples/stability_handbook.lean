/-
# stability_handbook: Extended Bifurcation Reference

Comprehensive reference for stability_handbook.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== stability_handbook ==="
def fstability_handbook (x : Rat) : Rat := x + (1:Rat)/10 - x*x
def dstability_handbook (x : Rat) : Rat := 1 - 2*x
def gstability_handbook : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
#eval (List.filter (fun x => fstability_handbook x == x) gstability_handbook).length
#eval fixedPointCount fstability_handbook gstability_handbook
#eval periodicPointCount fstability_handbook gstability_handbook 1
#eval periodicPointCount fstability_handbook gstability_handbook 2
#eval topologicalEntropyApprox fstability_handbook gstability_handbook 10
#eval isStructurallyStable fstability_handbook dstability_handbook gstability_handbook
#eval polynomialCriticalPoints ({ coeffs := [0, 1, -1] } : Polynomial) gstability_handbook
#eval classifyCriticalPoint ({ coeffs := [0, 1, -1] } : Polynomial) ((1:Rat)/2)
#eval periodicOrbitMultiplier fstability_handbook dstability_handbook 0 1
#eval isStructurallyStable1D fstability_handbook dstability_handbook [1,2] gstability_handbook
#eval birkhoffAverage fstability_handbook (fun x => x) 0 100
#eval isErgodicApprox fstability_handbook (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, (1+sqrtRat 6), ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## stability_handbook Additional Checks -/
def famstability_handbook : ParameterFamily Rat Rat := { f := fun mu x => x + mu - x*x }
#eval famstability_handbook.f 0 0
#eval ParameterFamily.iterate famstability_handbook ((1:Rat)/4) 10 0

def dsstability_handbook : DiscreteDS Rat := { f := fun x => 2*x }
#eval dsstability_handbook.iterate 0 1
#eval dsstability_handbook.iterate 5 1
#eval orbit dsstability_handbook.f 1 5

def polystability_handbook : Polynomial := { coeffs := [0, 1, 0, -1] }
#eval polystability_handbook.eval 0
#eval polystability_handbook.eval 1
#eval polystability_handbook.eval 2
#eval polystability_handbook.derivAt 0
#eval polystability_handbook.derivAt 1

#eval codimension .saddleNode
#eval codimension .periodDoubling
#eval codimension .hopf
#eval codimension .transcritical
#eval codimension (.pitchfork true)

#eval "=== stability_handbook Complete ==="
