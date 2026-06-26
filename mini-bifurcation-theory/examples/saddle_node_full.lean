/-
# saddle_node_full: Extended Bifurcation Reference

Comprehensive reference for saddle_node_full.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== saddle_node_full ==="
def fsaddle_node_full (x : Rat) : Rat := x + (1:Rat)/10 - x*x
def dsaddle_node_full (x : Rat) : Rat := 1 - 2*x
def gsaddle_node_full : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
#eval (List.filter (fun x => fsaddle_node_full x == x) gsaddle_node_full).length
#eval fixedPointCount fsaddle_node_full gsaddle_node_full
#eval periodicPointCount fsaddle_node_full gsaddle_node_full 1
#eval periodicPointCount fsaddle_node_full gsaddle_node_full 2
#eval topologicalEntropyApprox fsaddle_node_full gsaddle_node_full 10
#eval isStructurallyStable fsaddle_node_full dsaddle_node_full gsaddle_node_full
#eval polynomialCriticalPoints ({ coeffs := [0, 1, -1] } : Polynomial) gsaddle_node_full
#eval classifyCriticalPoint ({ coeffs := [0, 1, -1] } : Polynomial) ((1:Rat)/2)
#eval periodicOrbitMultiplier fsaddle_node_full dsaddle_node_full 0 1
#eval isStructurallyStable1D fsaddle_node_full dsaddle_node_full [1,2] gsaddle_node_full
#eval birkhoffAverage fsaddle_node_full (fun x => x) 0 100
#eval isErgodicApprox fsaddle_node_full (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, (1+sqrtRat 6), ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## saddle_node_full Additional Checks -/
def famsaddle_node_full : ParameterFamily Rat Rat := { f := fun mu x => x + mu - x*x }
#eval famsaddle_node_full.f 0 0
#eval ParameterFamily.iterate famsaddle_node_full ((1:Rat)/4) 10 0

def dssaddle_node_full : DiscreteDS Rat := { f := fun x => 2*x }
#eval dssaddle_node_full.iterate 0 1
#eval dssaddle_node_full.iterate 5 1
#eval orbit dssaddle_node_full.f 1 5

def polysaddle_node_full : Polynomial := { coeffs := [0, 1, 0, -1] }
#eval polysaddle_node_full.eval 0
#eval polysaddle_node_full.eval 1
#eval polysaddle_node_full.eval 2
#eval polysaddle_node_full.derivAt 0
#eval polysaddle_node_full.derivAt 1

#eval codimension .saddleNode
#eval codimension .periodDoubling
#eval codimension .hopf
#eval codimension .transcritical
#eval codimension (.pitchfork true)

#eval "=== saddle_node_full Complete ==="
