/-
# normal_form_catalog: Extended Bifurcation Reference

Comprehensive reference for normal_form_catalog.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== normal_form_catalog ==="
def fnormal_form_catalog (x : Rat) : Rat := x + (1:Rat)/10 - x*x
def dnormal_form_catalog (x : Rat) : Rat := 1 - 2*x
def gnormal_form_catalog : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
#eval (List.filter (fun x => fnormal_form_catalog x == x) gnormal_form_catalog).length
#eval fixedPointCount fnormal_form_catalog gnormal_form_catalog
#eval periodicPointCount fnormal_form_catalog gnormal_form_catalog 1
#eval periodicPointCount fnormal_form_catalog gnormal_form_catalog 2
#eval topologicalEntropyApprox fnormal_form_catalog gnormal_form_catalog 10
#eval isStructurallyStable fnormal_form_catalog dnormal_form_catalog gnormal_form_catalog
#eval polynomialCriticalPoints ({ coeffs := [0, 1, -1] } : Polynomial) gnormal_form_catalog
#eval classifyCriticalPoint ({ coeffs := [0, 1, -1] } : Polynomial) ((1:Rat)/2)
#eval periodicOrbitMultiplier fnormal_form_catalog dnormal_form_catalog 0 1
#eval isStructurallyStable1D fnormal_form_catalog dnormal_form_catalog [1,2] gnormal_form_catalog
#eval birkhoffAverage fnormal_form_catalog (fun x => x) 0 100
#eval isErgodicApprox fnormal_form_catalog (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, (1+sqrtRat 6), ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## normal_form_catalog Additional Checks -/
def famnormal_form_catalog : ParameterFamily Rat Rat := { f := fun mu x => x + mu - x*x }
#eval famnormal_form_catalog.f 0 0
#eval ParameterFamily.iterate famnormal_form_catalog ((1:Rat)/4) 10 0

def dsnormal_form_catalog : DiscreteDS Rat := { f := fun x => 2*x }
#eval dsnormal_form_catalog.iterate 0 1
#eval dsnormal_form_catalog.iterate 5 1
#eval orbit dsnormal_form_catalog.f 1 5

def polynormal_form_catalog : Polynomial := { coeffs := [0, 1, 0, -1] }
#eval polynormal_form_catalog.eval 0
#eval polynormal_form_catalog.eval 1
#eval polynormal_form_catalog.eval 2
#eval polynormal_form_catalog.derivAt 0
#eval polynormal_form_catalog.derivAt 1

#eval codimension .saddleNode
#eval codimension .periodDoubling
#eval codimension .hopf
#eval codimension .transcritical
#eval codimension (.pitchfork true)

#eval "=== normal_form_catalog Complete ==="
